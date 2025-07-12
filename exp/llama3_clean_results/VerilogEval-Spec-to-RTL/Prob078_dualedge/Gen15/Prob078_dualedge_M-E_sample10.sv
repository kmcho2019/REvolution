module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals for edge detection
reg pos_edge;
reg neg_edge;
reg prev_clk;

// Edge detection logic
always @(posedge clk) begin
    prev_clk <= clk;
    pos_edge <= 1'b1;
    neg_edge <= 1'b0;
end

always @(negedge clk) begin
    prev_clk <= clk;
    pos_edge <= 1'b0;
    neg_edge <= 1'b1;
end

always @(posedge clk) begin
    if (prev_clk == 1'b0) begin // Positive edge
        q <= d;
    end else if (prev_clk == 1'b1) begin // Negative edge
        q <= d;
    end
end

endmodule