module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg = 8'b0;  // Initialize q_reg to 0

always @(posedge clk) begin
    q_reg <= {d, q_reg[7:1]};  // Shift right and insert new bit
end

assign q = q_reg;  // Assign the output

endmodule