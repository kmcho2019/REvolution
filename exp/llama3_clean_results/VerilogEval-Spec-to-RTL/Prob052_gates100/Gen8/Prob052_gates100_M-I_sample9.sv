module TopModule(
    input  [99:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(in) begin
        out_and = &in;  // Reduction AND operation
        out_or  = |in;  // Reduction OR operation
        out_xor = ^in;  // Reduction XOR operation
    end

endmodule