module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_capture;  // Value captured on positive edge
reg neg_capture;  // Value captured on negative edge

always @(posedge clk) begin
    pos_capture <= d;
end

always @(negedge clk) begin
    neg_capture <= d;
end

always @(posedge clk or negedge clk) begin
    q <= (clk)? pos_capture : neg_capture;
end

endmodule