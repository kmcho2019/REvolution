module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    q = ~(a ^ b ^ c ^ d); // Even parity: invert XOR of all inputs
end

endmodule