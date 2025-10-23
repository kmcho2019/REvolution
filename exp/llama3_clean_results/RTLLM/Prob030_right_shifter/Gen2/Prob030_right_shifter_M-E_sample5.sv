module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;  // Internal register to hold the shift operation result

// Initialize the internal register to 0
initial
    q_reg = 8'd0;

// Update the internal register on each rising edge of the clock
always @ (posedge clk)
begin
    q_reg[7] <= d;  // Shift the input bit d into the most significant bit position
    for (int i = 6; i >= 0; i--)  // Propagate the bits through the register
    begin
        q_reg[i] <= q_reg[i + 1];  // Shift each bit to the right
    end
end

// Assign the internal register to the output
assign q = q_reg;

endmodule