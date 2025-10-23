module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

    always @(*) begin
        // XOR all inputs inside procedural block
        out = a ^ b ^ c ^ d;
    end

endmodule