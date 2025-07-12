module right_shifter (
    input wire clk,
    input wire reset_n,  // Active-low reset
    input wire d,
    input wire enable,   // Shift enable control
    output wire [7:0] q
);

// Internal register
reg [7:0] shift_reg;

// Sequential logic with enable and reset
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 8'b0;  // Reset condition
    end
    else if (enable) begin
        shift_reg <= {d, shift_reg[7:1]};  // Combined shift and enable
    end
end

// Output assignment
assign q = shift_reg;

endmodule