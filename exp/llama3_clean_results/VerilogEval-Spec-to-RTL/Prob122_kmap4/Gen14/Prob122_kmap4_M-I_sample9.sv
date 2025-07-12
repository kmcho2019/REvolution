module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    always @(*) begin
        // Direct implementation of the XOR operation among all inputs
        // This matches the observation from the Karnaugh map
        out = a ^ b ^ c ^ d;
    end

endmodule