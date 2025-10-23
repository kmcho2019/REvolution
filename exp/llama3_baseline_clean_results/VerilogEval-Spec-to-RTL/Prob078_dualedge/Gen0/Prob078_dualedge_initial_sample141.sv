module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;
reg q_reg_pos;
reg q_reg_neg;

// Inverted clock
reg clk_inv;

// Invert the clock
always @(posedge clk or negedge clk) begin
    clk_inv <= ~clk;
end

// Positive edge triggered flip-flop
always @(posedge clk) begin
    q_reg_pos <= d;
end

// Negative edge triggered flip-flop (using the inverted clock)
always @(posedge clk_inv) begin
    q_reg_neg <= d;
end

// Combine the outputs
assign q = (clk == 1'b1) ? q_reg_pos : q_reg_neg;

endmodule