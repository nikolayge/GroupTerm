package AAFMAAProject.ATResults;

import java.util.Collection;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import tests.com.sabratec.applinx.server.designtime.entities.procedure.junit.TestCase;

@RunWith(value = Parameterized.class)
public class ATResults extends TestCase {

	public ATResults(TestData testData) {
		super(testData);
	}

	/**
	 * Using the default "String[] fileNames = {"*"};" runs the test with all test data JSON files in the resource folder.
	 * You can also limit the test to one or more specific test data files, for example:
	 * String[] fileNames = {"myFileName.json", "anotherFileName.json"}; runs the test twice – once with the test data specified in file "myFileName.json", 
	 * then with data specified in "anotherFileName.json".
	 */
	@Parameters(name = "{0}")
	public static Collection <Object[]> getTestData() {
		String[] fileNames = {"*"};
		return TestCase.getTestData(fileNames);
	}
	
	@Test
    public void test() {
		run();
    }
}
