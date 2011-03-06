package net.sourceforge.squirrel_sql.fw.datasetviewer.cellcomponent;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertEquals;

import java.lang.reflect.Field;
import java.sql.Date;
import java.text.NumberFormat;

import net.sourceforge.squirrel_sql.fw.datasetviewer.ColumnDisplayDefinition;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/*
 * Copyright (C) 2006 Rob Manning
 * manningr@users.sourceforge.net
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/**
 * JUnit test for DataTypeFloat class.
 * 
 * @author manningr
 */
public class DataTypeFloatTest extends FloatingPointBaseTest <Float> {


	@Before
	public void setUp() throws Exception {
		initClassUnderTest();
		super.setUp();

	}
	
	@Override
	protected Object getEqualsTestObject() {
		return Float.valueOf(1);
	}

	@Override
	@Test
	public void testGetWhereClauseValue() {
		ColumnDisplayDefinition localMockColumnDisplayDefinition = getMockColumnDisplayDefinition();
		mockHelper.replayAll();
		classUnderTest.setColumnDisplayDefinition(localMockColumnDisplayDefinition);
		assertNotNull(classUnderTest.getWhereClauseValue(null, mockMetaData));
		// Floats cannot be used as where clause values as there are not
		// precise.
		assertNull(classUnderTest.getWhereClauseValue(getWhereClauseValueObject(), mockMetaData));
		mockHelper.verifyAll();
	}

	@Override
	protected void initClassUnderTest() {
		ColumnDisplayDefinition mockColumnDisplayDefinition = getMockColumnDisplayDefinition();
		mockHelper.replayAll();
		classUnderTest = new DataTypeFloat(null, mockColumnDisplayDefinition);
		mockHelper.resetAll();		
	}

	@Override
	protected Float getValueForRenderingTests() {
		return new Float(1234.1456789F);
	}
}
