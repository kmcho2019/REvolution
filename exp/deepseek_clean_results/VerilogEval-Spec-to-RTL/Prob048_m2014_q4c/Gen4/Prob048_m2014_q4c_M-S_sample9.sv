module TopModule(
    input  clk,
    input  r,
    input  d,
    output reg q
);

always @(posedge clk) begin
    if (r) q <= 1'b0;
    else   q <= d;
end

endmodule