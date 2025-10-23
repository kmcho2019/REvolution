module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg pos_q;
reg neg_q;

always @(posedge clk) begin
    pos_q <= d;
    q <= pos_q;
end

always @(negedge clk) begin
    neg_q <= d;
    q <= neg_q;
end

endmodule