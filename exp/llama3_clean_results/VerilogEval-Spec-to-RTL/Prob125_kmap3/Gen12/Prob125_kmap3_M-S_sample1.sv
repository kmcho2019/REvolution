module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output reg out
);

always @(*) begin
    out = a || (!b && c);
end

endmodule