module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;  // Internal register to hold the shifted value

always @(posedge clk) begin
    q_reg[7] <= d;  // Shift in the new bit into the most significant position
    for (int i = 6; i >= 0; i--) begin
        q_reg[i] <= q_reg[i+1];  // Shift the bits to the right
    end
end

assign q = q_reg;  // Assign the internal register value to the output

endmodule