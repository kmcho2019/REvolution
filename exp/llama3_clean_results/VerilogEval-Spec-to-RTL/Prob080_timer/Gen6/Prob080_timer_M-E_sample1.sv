module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] shift_reg;

assign tc = shift_reg[9]; // Assert tc when MSB is 1

always @(posedge clk)
    if (load)
        shift_reg <= {10{1'b0}} | (data != 10'd0); // Load data into shift register, ensuring MSB is 1 if data is not 0
    else if (shift_reg != 10'd0) // If shift register is not all zeros
        shift_reg <= {shift_reg[8:0], 1'b0}; // Shift bits to the right, filling with zeros

endmodule