module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q_reg;

always @(posedge clk) begin
    // Explicitly defining the shifted bits for clarity
    reg [6:0] shifted_bits;
    shifted_bits = q_reg[6:0];
    q_reg <= {d, shifted_bits};
end

assign q = q_reg;

endmodule