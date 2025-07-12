module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] shift_reg;  // Internal shift register

always @(posedge clk) begin
    // Shift the contents of the shift register to the right by one bit
    shift_reg <= {d, shift_reg[7:1]};
    // Assign the value of the shift register to the output 'q'
    q <= shift_reg;
end

endmodule