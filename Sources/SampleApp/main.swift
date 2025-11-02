import ChatGPTSwift
import Foundation

let api = ChatGPTAPI(apiKey: "apikey")

// Example 1: Text-only message
print("=== Example 1: Text-only message ===")
let textPrompt = "What is OpenAI?"
Task {
    do {
        let stream = try await api.sendMessageStream(text: textPrompt, model: .gpt_hyphen_4o)
        var responseText = ""
        for try await line in stream {
            responseText += line
            print(line, terminator: "")
        }
        api.appendToHistoryList(userText: textPrompt, responseText: responseText)
        print("\nResponse: \(responseText)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }

    // Example 2: Message with base64-encoded image
    print("\n=== Example 2: Message with base64-encoded image ===")

    // For demo purposes, we'll create a small dummy image data
    // In real usage, you would load actual image data
    let dummyImageData = Data("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==".utf8)

    do {
        let imagePrompt = "What's in this image?"
        let images: [ImageContent] = [.base64(dummyImageData, detail: .auto)]
        let stream = try await api.sendMessageStream(text: imagePrompt, model: .gpt_hyphen_4o, images: images)
        var responseText = ""
        for try await line in stream {
            responseText += line
            print(line, terminator: "")
        }
        api.appendToHistoryList(userText: imagePrompt, responseText: responseText)
        print("\nResponse: \(responseText)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }

    // Example 3: Message with image URL
    print("\n=== Example 3: Message with image URL ===")

    do {
        let imagePrompt = "Describe this image in detail."
        let imageUrl = "https://example.com/image.jpg" // Replace with actual image URL
        let images: [ImageContent] = [.url(imageUrl, detail: .high)]
        let stream = try await api.sendMessageStream(text: imagePrompt, model: .gpt_hyphen_4o, images: images)
        var responseText = ""
        for try await line in stream {
            responseText += line
            print(line, terminator: "")
        }
        api.appendToHistoryList(userText: imagePrompt, responseText: responseText)
        print("\nResponse: \(responseText)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }

    // Example 4: Message with multiple images
    print("\n=== Example 4: Message with multiple images ===")

    do {
        let multiImagePrompt = "Compare these two images."
        let images: [ImageContent] = [
            .url("https://example.com/image1.jpg", detail: .high),
            .base64(dummyImageData, detail: .low)
        ]
        let stream = try await api.sendMessageStream(text: multiImagePrompt, model: .gpt_hyphen_4o, images: images)
        var responseText = ""
        for try await line in stream {
            responseText += line
            print(line, terminator: "")
        }
        api.appendToHistoryList(userText: multiImagePrompt, responseText: responseText)
        print("\nResponse: \(responseText)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }

    exit(0)
}

RunLoop.main.run(until: .distantFuture)