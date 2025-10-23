module TopModule(
    input clk,
    input d,
    output reg q
);

// Positive-edge triggered flip-flop
reg pos_ff;
always @(posedge clk) begin
    pos_ff <= d;
end

// Negative-edge triggered flip-flop
reg neg_ff;
always @(negedge clk) begin
    neg_ff <= d;
end

// Directly assign output based on clock edge
always @(*) begin
    if (clk == 1'b1) begin
        q = pos_ff;
    end else begin
        q = neg_ff;
    end
end

endmodule