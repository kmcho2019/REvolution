module TopModule (
    input  [99:0] in,
    output reg    out_and,  // Output is logical AND of all 100 inputs
    output reg    out_or,   // Output is logical OR  of all 100 inputs
    output reg    out_xor   // Output is logical XOR of all 100 inputs (parity)
);

    always @(*) begin
        // Perform reduction operations to combine all input bits
        out_and = &in;  // Reduction AND: High only if all inputs are 1
        out_or  = |in;  // Reduction OR:  High if any input is 1
        out_xor = ^in;  // Reduction XOR: Parity of all inputs (1 if odd number of 1s)
    end

endmodule