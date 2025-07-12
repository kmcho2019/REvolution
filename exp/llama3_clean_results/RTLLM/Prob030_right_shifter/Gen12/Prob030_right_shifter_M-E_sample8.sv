module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Internal signal to store the current state of the shift register
reg [7:0] shift_reg;

// Always block to update the shift register on each rising edge of the clock
always @(posedge clk) begin
    shift_reg <= {d, shift_reg[7:1]};
    q <= shift_reg;
end

// Initialize the shift register to 0
initial shift_reg = 8'd0;

endmodule