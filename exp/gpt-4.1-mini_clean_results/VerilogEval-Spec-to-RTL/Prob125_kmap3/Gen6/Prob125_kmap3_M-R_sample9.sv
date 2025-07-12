module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // don't-care, unused
    output reg out
);

always @(*) begin
    if (a) begin
        out = 1'b1;
    end else begin
        out = c & ~b;
    end
end

endmodule