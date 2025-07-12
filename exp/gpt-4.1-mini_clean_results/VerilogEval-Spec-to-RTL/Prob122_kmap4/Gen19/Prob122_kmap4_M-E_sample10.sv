module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    // Use a vector to combine inputs and reduction XOR operator for parity
    always @(*) begin
        out = ^{a, b, c, d};  // reduction XOR of inputs
    end

endmodule