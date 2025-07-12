module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg = 8'd0; // Initialize q_reg to 0

always @(posedge clk) begin
    q_reg <= (q_reg >> 1) | (d << 7); // Shift q_reg right by 1 and insert d at the most significant bit
end

assign q = q_reg;

endmodule