module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // don't-care, unused
    output reg out
);

always @(*) begin
    if (a)
        out = 1'b1;
    else
        out = c & ~b;
end

endmodule