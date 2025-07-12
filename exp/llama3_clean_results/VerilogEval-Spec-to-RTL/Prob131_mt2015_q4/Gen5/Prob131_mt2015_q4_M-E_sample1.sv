module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implement the logic for z based on the analysis of the truth table
    // The XOR operation at the final stage suggests we are looking for a situation
    // where either the condition from the first set of submodules or the second set
    // is true, but not both. This can be simplified into a direct implementation.
    assign z = (x && !y) || (!x && !y) || (x && y && x && y);
endmodule