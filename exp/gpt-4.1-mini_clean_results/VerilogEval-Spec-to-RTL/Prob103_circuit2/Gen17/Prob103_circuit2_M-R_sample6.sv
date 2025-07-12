module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(*) begin
    // Compute parity and invert it to get q
    q = ~ (a ^ b ^ c ^ d);
end

endmodule