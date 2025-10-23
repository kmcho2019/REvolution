module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

reg p1y_temp;
reg p2y_temp;

always @(*) begin
    p1y_temp = ~(p1a & p1b & p1c & p1d);
    p2y_temp = ~(p2a & p2b & p2c & p2d);
end

assign p1y = p1y_temp;
assign p2y = p2y_temp;

endmodule