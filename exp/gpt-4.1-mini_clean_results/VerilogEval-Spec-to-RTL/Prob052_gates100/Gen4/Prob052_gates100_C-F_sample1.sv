module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);

    // Use an always_comb block for clear combinational logic semantics
    always @(*) begin
        out_and = &in;  // Reduction AND
        out_or  = |in;  // Reduction OR
        out_xor = ^in;  // Reduction XOR
    end

endmodule