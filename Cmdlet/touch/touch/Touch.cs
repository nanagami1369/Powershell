using System;
using System.IO;
using System.Management.Automation;

namespace Touch
{
    [CmdletBinding()]
    [Cmdlet(VerbsData.Update, "Item")]
    public class Touch : PSCmdlet
    {
        [Parameter(ValueFromPipeline = true, Position = 1, Mandatory = true)]
        [ValidateNotNullOrEmpty()]
        public string Path { get; set; }

        protected sealed override void ProcessRecord()
        {
                Do(Path);
            
        }

        private void Do(string path)
        {
            if (!System.IO.Path.IsPathRooted(path))
            {
                path = System.IO.Path.Combine(SessionState.Path.CurrentLocation.Path, path);
            }

            var DirectoryExists = Directory.Exists(path);
            var FileExists = File.Exists(path);
            if (DirectoryExists)
            {
                Directory.SetLastWriteTime(path, DateTime.Now);
                return;
            }

            if (FileExists)
            {
                File.SetLastWriteTime(path, DateTime.Now);
                return;
            }

            var baseDirectory = System.IO.Path.GetDirectoryName(path);
            var baseDirectoryExists = string.IsNullOrEmpty(baseDirectory) || Directory.Exists(baseDirectory);
            if (baseDirectoryExists)
            {
                File.Create(path);
                return;
            }

            throw new DirectoryNotFoundException("ベースディレクトリが存在していません");
        }
    }
}