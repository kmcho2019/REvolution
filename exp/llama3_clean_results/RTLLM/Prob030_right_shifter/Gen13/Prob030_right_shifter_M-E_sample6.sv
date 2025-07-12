module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;  // Internal shift register

initial q_reg = 8'd0;  // Initialize q_reg to 0

always @(posedge clk) begin
    q_reg[7] <= d;  // Insert new input bit at most significant position
    for (int i = 6; i >= 0; i--) begin
        q_reg[i] <= q_reg[i + 1];  // Shift bits to the right
    end
end

assign q = q_reg;  // Assign output

endmodule