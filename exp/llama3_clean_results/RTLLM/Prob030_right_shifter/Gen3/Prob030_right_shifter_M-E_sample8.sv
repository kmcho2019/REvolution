module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;  // Internal register to store the shifted bits

// Initialize the internal register to 0
initial
    q_reg = 8'd0;

// Shift the bits to the right on each rising edge of the clock
always @ (posedge clk)
begin
    q_reg[7] <= d;  // Feed the input signal into the MSB flip-flop
    for (int i = 6; i >= 0; i--)  // Shift the bits to the right
    begin
        q_reg[i] <= q_reg[i + 1];  // Connect the output of each flip-flop to the input of the next
    end
end

// Assign the internal register to the output
assign q = q_reg;

endmodule