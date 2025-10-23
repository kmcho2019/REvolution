module TopModule(
    input  d,
    input  ena,
    output reg q
);
always @(posedge ena) begin
    q <= d;
end

endmodule