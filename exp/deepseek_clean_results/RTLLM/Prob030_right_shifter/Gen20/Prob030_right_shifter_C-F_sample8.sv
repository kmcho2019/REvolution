module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire d,
    input wire enable,
    output wire [WIDTH-1:0] q
);

// Latch-based clock gating for better timing
reg gated_clk;
always @(*) begin
    if (~clk) gated_clk = clk & enable;
end

// Main shift register
reg [WIDTH-1:0] q_reg;
assign q = q_reg;

always @(posedge gated_clk) begin
    q_reg <= {d, q_reg[WIDTH-1:1]};  // Efficient right shift with MSB insertion
end

// Initialize register
initial begin
    q_reg = {WIDTH{1'b0}};
end

endmodule