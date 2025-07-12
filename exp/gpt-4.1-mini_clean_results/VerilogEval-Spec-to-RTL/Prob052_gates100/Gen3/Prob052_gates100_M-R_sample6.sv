module TopModule (
    input  [99:0] in,
    output reg    out_and,  // Reduction AND of all 100 input bits
    output reg    out_or,   // Reduction OR  of all 100 input bits
    output reg    out_xor   // Reduction XOR of all 100 input bits
);

    always @(*) begin
        out_and = &in;  // Compute AND reduction of inputs
        out_or  = |in;  // Compute OR  reduction of inputs
        out_xor = ^in;  // Compute XOR reduction of inputs
    end

endmodule