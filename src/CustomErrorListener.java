import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

import java.util.ArrayList;
import java.util.List;

public class CustomErrorListener extends BaseErrorListener {

    public static List<String> lexicalErrors = new ArrayList<>();

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
                            int line, int charPositionInLine, String msg, RecognitionException e) {

        String errorMsg = String.format("العمود: %d - السطر: %d | Error at: Invalid or unexpected token (Line %d, Col %d)",
                charPositionInLine, line, line, charPositionInLine);
        lexicalErrors.add(errorMsg);
    }
}