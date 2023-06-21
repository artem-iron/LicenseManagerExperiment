using LicensesNamespace;
using Newtonsoft.Json;
using System.Buffers;
using System.Buffers.Text;
using System.Reflection;
using System.Text;

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
                $"Path: {typeof(LicenseManager).Assembly.Location}\n" +
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

    public static string StringFromParser
    {
        get
        {
            Console.WriteLine($"Method: {MethodBase.GetCurrentMethod()}\n" +
                $"Type: {typeof(StandardFormat).FullName}\n" +
                $"Assembly: {typeof(StandardFormat).Assembly.FullName}\n" +
                $"Path: {typeof(StandardFormat).Assembly.Location}");

            ReadOnlySpan<byte> span = Encoding.UTF8.GetBytes(LicenseManager.LicenseKey);

            return Utf8Parser.TryParse(span, out int value, out int bytesConsumed)
                ? $"{value}; bytes consumed: {bytesConsumed}"
                : "Parsing failed";
        }
    }

    public static string JsonString
    {
        get
        {
            Console.WriteLine($"Method: {MethodBase.GetCurrentMethod()}\n" +
                $"Type: {typeof(JsonSerializer).FullName}\n" +
                $"Assembly: {typeof(JsonSerializer).Assembly.FullName}\n" +
                $"Path: {typeof(JsonSerializer).Assembly.Location}");

            return JsonSerializer.Create().DateFormatString;
        }
    }
}