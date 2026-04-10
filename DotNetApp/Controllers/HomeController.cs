using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace DotNetApp.Controllers;

public class HomeController : Controller
{
    public HomeController()
    {
    }

    public IActionResult Index()
    {
        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }
}
