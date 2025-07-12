module TopModule(
    input  a,
    input  b,
    output q
);

    // Using a 2-to-1 multiplexer to mimic AND gate behavior
    // The inputs to the MUX are 0 (for cases where a or b is 0) and 1 (for the case where both a and b are 1)
    // The select lines are 'a' and 'b', but since we're using a single select line in a 2-to-1 MUX, we need to combine 'a' and 'b' to act as this line
    wire sel;
    assign sel = a & b; // This will be 1 only when both 'a' and 'b' are 1, which is when we want to select the '1' input
    
    // Implementing the 2-to-1 MUX
    assign q = (sel) ? 1 : 0;

endmodule