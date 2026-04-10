using Xunit;
using FluentAssertions;
using DotNetApp.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace DotNetApp.Tests.Controllers;

public class HomeControllerTests
{
    [Fact]
    public void Index_ReturnsViewResult()
    {
        // Arrange
        var controller = new HomeController();

        // Act
        var result = controller.Index();

        // Assert
        result.Should().BeOfType<ViewResult>();
    }

    [Fact]
    public void Privacy_ReturnsViewResult()
    {
        // Arrange
        var controller = new HomeController();

        // Act
        var result = controller.Privacy();

        // Assert
        result.Should().BeOfType<ViewResult>();
    }
}
