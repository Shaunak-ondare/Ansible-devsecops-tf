using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;
using FluentAssertions;

namespace DotNetApp.Tests;

public class ViewTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public ViewTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Get_HomePage_ContainsExpectedContent()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/");
        var content = await response.Content.ReadAsStringAsync();

        // Assert
        response.EnsureSuccessStatusCode();
        content.Should().Contain("Future of .NET");
        content.Should().Contain("Infrastructure");
    }

    [Fact]
    public async Task Get_PrivacyPage_ContainsExpectedContent()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/Home/Privacy");
        var content = await response.Content.ReadAsStringAsync();

        // Assert
        response.EnsureSuccessStatusCode();
        content.Should().Contain("Privacy");
        content.Should().Contain("DevOps");
    }

    [Fact]
    public async Task Get_StaticStyleSheet_ReturnsSuccess()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/css/site.css");

        // Assert
        response.EnsureSuccessStatusCode();
        response.Content.Headers.ContentType!.ToString().Should().Contain("text/css");
    }
}
