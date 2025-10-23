module TopModule(
    input  d,
    input  ena,
    output reg q = 1'b0
);

always @(*) begin
    if (ena) q <= d;
end

endmodule