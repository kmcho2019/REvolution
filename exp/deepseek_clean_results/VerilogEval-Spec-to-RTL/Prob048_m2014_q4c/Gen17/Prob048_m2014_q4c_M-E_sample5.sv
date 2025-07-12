module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

reg q_reg;
wire clk_en;
reg d_prev, r_prev;

// Detect changes in inputs
always @(posedge clk) begin
    d_prev <= d;
    r_prev <= r;
end

// Generate clock enable when inputs change or reset is active
assign clk_en = (d != d_prev) || (r != r_prev) || r;

// Gated clock
wire gated_clk = clk & clk_en;

// Main flip-flop with synchronous reset
always @(posedge gated_clk) begin
    if (r)
        q_reg <= 1'b0;
    else
        q_reg <= d;
end

assign q = q_reg;

endmodule