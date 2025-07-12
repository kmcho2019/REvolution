module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

    reg [7:0] shift_reg;  // Internal shift register

    always @(posedge clk) begin
        shift_reg <= {d, shift_reg[7:1]};  // Shift input signal d into the shift register
    end

    assign q = shift_reg;  // Assign the output of the shift register to the output q

endmodule