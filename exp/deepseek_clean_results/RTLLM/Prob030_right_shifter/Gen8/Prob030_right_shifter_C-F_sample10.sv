module right_shifter (
    input clk,
    input reset_n,    // Active-low synchronous reset
    input enable,     // Enable signal for power gating
    input d,          // Input bit
    output [7:0] q    // Shifted output
);

reg [7:0] shift_reg;
reg d_reg;           // Registered input to break timing path

// Input registration
always @(posedge clk) begin
    d_reg <= d;
end

// Shift operation with enable and reset
always @(posedge clk) begin
    if (!reset_n) begin
        shift_reg <= 8'b0;
    end
    else if (enable) begin
        shift_reg <= {d_reg, shift_reg[7:1]};
    end
end

// Output assignment
assign q = shift_reg;

// Simulation initialization
initial begin
    shift_reg = 8'b0;
    d_reg = 1'b0;
end

endmodule