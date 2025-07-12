module TopModule(
    input  [3:0] in,
    output reg out_and,
    output reg out_or,
    output reg out_xor
);

    always @(*) begin
        out_and = &in; // Reduction AND operator (&) applied to vector in
        out_or  = |in; // Reduction OR operator (|) applied to vector in
        out_xor = ^in; // Reduction XOR operator (^) applied to vector in
    end

endmodule