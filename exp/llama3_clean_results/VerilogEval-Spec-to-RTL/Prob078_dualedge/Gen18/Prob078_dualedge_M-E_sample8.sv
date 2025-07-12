module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_div;  // Clock divider output
reg q_reg;    // Flip-flop output

// Clock divider (simple delay)
always @(posedge clk) begin
    clk_div <= ~clk_div;
end

// Single flip-flop with clock enable
always @(posedge clk_div) begin
    if (clk) begin
        q_reg <= d;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule