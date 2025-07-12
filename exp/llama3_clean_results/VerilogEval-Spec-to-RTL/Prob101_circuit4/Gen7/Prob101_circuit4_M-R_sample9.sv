module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

always @(b, c) begin
    q = b || c;
end

endmodule