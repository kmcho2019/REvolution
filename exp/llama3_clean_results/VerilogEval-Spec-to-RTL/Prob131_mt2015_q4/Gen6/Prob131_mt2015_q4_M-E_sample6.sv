module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly compute z based on the conditions
    // If x and y are equal, z should be the result of (x^y) & x, which simplifies to 0 when x=y
    // If x and y are not equal, z should be the XOR of the OR and AND operations, which can be simplified
    assign z = (x == y)? ((x ^ y) & x) : ((x ^ y) & x) ^ ((x ^ y) & x);
    
    // Simplify the expression further
    // Since (x == y) results in ((x ^ y) & x) being 0, we can simplify to:
    assign z = (x!= y)? ((x ^ y) & x) ^ ((x ^ y) & x) : 0;
    
    // Further simplification
    // Recognize that ((x ^ y) & x) ^ ((x ^ y) & x) is essentially 0 because XORing a value with itself results in 0
    assign z = (x!= y)? 0 : (x == y);
    
    // Final simplification based on the observation of the waveform and logic conditions
    assign z = (x == y) && (x == 1) || (x == 0 && y == 0);
    
    // This can be further simplified into a more straightforward logical expression
    assign z = (x && y) || (!x &&!y);
endmodule