module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
reg prev_clk;

// Detect rising edge of clk
always @(clk) begin
    prev_clk <= clk;
end
wire clk_rise = ~prev_clk & clk;

// Implement flip-flops using continuous assignment
assign q = areset ? 8'b0 : (clk_rise ? d : q_reg);

// Store previous value
always @(*) begin
    q_reg = q;
end

endmodule