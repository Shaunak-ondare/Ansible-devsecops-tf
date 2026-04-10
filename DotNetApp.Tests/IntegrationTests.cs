using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;
using System.Net;
using FluentAssertions;

namespace DotNetApp.Tests;

public class IntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public IntegrationTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Theory]
    [InlineData("/")]
    [InlineData("/Home/Privacy")]
    public async Task Get_EndpointsReturnSuccessAndCorrectContentType(string url)
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync(url);

        // Assert
        response.EnsureSuccessStatusCode(); // Status Code 200-299
        response.Content.Headers.ContentType!.ToString().Should().Contain("text/html");
    }

    [Fact]
    public async Task Get_InvalidEndpointReturnsNotFound()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/non-existent-page");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }
}
