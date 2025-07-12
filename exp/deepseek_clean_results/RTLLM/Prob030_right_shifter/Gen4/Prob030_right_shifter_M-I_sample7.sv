module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] shift_reg;
reg d_reg;
wire clk_gated;
wire d_changed;

// Input registration for timing improvement
always @(posedge clk) begin
    d_reg <= d;
end

// Simple clock gating when input is stable
assign d_changed = (d_reg != d);
assign clk_gated = clk & (d_changed | (shift_reg != 8'b0));

// Shift operation with registered input
always @(posedge clk_gated) begin
    if (clk) begin  // Ensure proper clock behavior
        shift_reg <= {d_reg, shift_reg[7:1]};
    end
end

// Output assignment
assign q = shift_reg;

// Initialization
initial begin
    shift_reg = 8'b0;
    d_reg = 1'b0;
end

endmodule