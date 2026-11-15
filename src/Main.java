import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.Token;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {

        CharStream input = CharStreams.fromFileName("input.js");
        var lexer = new MiniJS(input);

        lexer.removeErrorListeners();
        CustomErrorListener errorListener = new CustomErrorListener();
        lexer.addErrorListener(errorListener);

        CustomErrorListener.lexicalErrors.clear();

        System.out.println("--- Tokens Found ---");
        for (Token token : lexer.getAllTokens()) {
            String tokenTypeName = lexer.getVocabulary().getSymbolicName(token.getType());

            boolean isError =
                    "ERROR_TOKEN".equals(tokenTypeName)
                            || tokenTypeName.startsWith("INVALID_")
                            || tokenTypeName.startsWith("UNTERMINATED_");

            if (isError) {

                String errorMsg = getErrorMsg(token, tokenTypeName);

                CustomErrorListener.lexicalErrors.add(errorMsg);

            } else {

                System.out.println(
                        "[Text: " + token.getText() +
                                "] -> Type: " + tokenTypeName +
                                " | Line: " + token.getLine() +
                                " | Column: " + (token.getCharPositionInLine() + 1)
                );
            }
        }

        System.out.println("\n--- Lexical Errors: " +
                CustomErrorListener.lexicalErrors.size() + " ---");

        if (CustomErrorListener.lexicalErrors.isEmpty()) {

            System.out.println("No lexical errors found.");

        } else {

            for (String error : CustomErrorListener.lexicalErrors) {
                System.out.println(error);
            }
        }
    }

    private static String getErrorMsg(Token token, String tokenTypeName) {
        String errorMessage;

        switch (tokenTypeName) {
            case "INVALID_EXPONENT" -> errorMessage = "Missing digits after exponent marker.";
            case "INVALID_HEX_NUMBER" -> errorMessage = "Invalid hexadecimal number. Expected digits from 0-9 or A-F.";
            case "INVALID_OCTAL_NUMBER" -> errorMessage = "Invalid octal number. Only digits 0-7 are allowed.";
            case "INVALID_BINARY_NUMBER" -> errorMessage = "Invalid binary number. Only 0 and 1 are allowed.";
            case "ERROR_TOKEN" -> errorMessage = "Unrecognized character.";
            case "INVALID_NUMBER_SUFFIX" -> errorMessage = "Identifier cannot immediately follow a numeric literal.";
            case "UNTERMINATED_COMMENT" -> errorMessage = "Multi-line comment was not closed. Expected '*/'.";
            case "UNTERMINATED_STRING" -> errorMessage = "String literal is not closed.";
            case "UNTERMINATED_TEMPLATE" -> errorMessage = "Template literal is not closed.";

            default -> errorMessage = "Invalid lexical token.";
        }
        String errorMsg =
                "Error at Line: " + token.getLine() +
                        ", Column: " + (token.getCharPositionInLine() + 1) +
                        "\nType: " + tokenTypeName +
                        "\nMessage: " + errorMessage +
                        "\nText: " + token.getText();
        return errorMsg;
    }
}