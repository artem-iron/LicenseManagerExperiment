using LicensesNamespace;
using System.Reflection;

namespace IronLib1;

public static class License
{
    public static string LicenseKey
    {
        get
        {
            Console.WriteLine($"Method: {MethodBase.GetCurrentMethod()}\n" +
                $"Type: {typeof(LicenseManager).FullName}\n" +
                $"Assembly: {typeof(LicenseManager).Assembly.FullName}\n" +
                $"Current value: {LicenseManager.LicenseKey}");
            return LicenseManager.LicenseKey;
        }

        set
        {
            Console.WriteLine($"Method: {MethodBase.GetCurrentMethod()}\n" +
                $"Type: {typeof(LicenseManager).FullName}\n" +
                $"Assembly: {typeof(LicenseManager).Assembly.FullName}\n" +
                $"Current value: {LicenseManager.LicenseKey}\n" +
                $"Value to set: {value}");
            LicenseManager.LicenseKey = value;
        }
    }
}