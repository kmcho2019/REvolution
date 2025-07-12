module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    always @(*) begin
        // Compute parity of inputs via XOR inside a procedural block
        out = a ^ b ^ c ^ d;
    end

endmodule