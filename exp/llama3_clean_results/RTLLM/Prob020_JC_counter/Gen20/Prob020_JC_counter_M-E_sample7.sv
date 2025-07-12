// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

reg [5:0] control_reg; // 6-bit control register

// Always block for control register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) control_reg <= 6'd0; // Reset condition
    else if (control_reg == 6'd63) control_reg <= 6'd0; // Wrap around
    else control_reg <= control_reg + 1'd1; // Increment control register
end

// Always block for 64-bit register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) Q <= 64'd0; // Reset condition
    else if (Q[0] == 1'b0) Q <= {1'b1, Q[63:1]}; // Shift right and append 1
    else Q <= {1'b0, Q[63:1]}; // Shift right and append 0
end

endmodule