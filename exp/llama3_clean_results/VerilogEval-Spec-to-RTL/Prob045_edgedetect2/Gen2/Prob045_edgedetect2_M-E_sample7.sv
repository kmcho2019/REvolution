module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] shift_reg;  // Shift register to store previous values

// Initialize the shift register
initial begin
    shift_reg = 8'b0;
end

// Sequential logic to update the shift register and detect edges
always @(posedge clk) begin
    // Shift the current input into the shift register
    shift_reg <= {in, 1'b0};  // Shift left by one bit, filling with 0
    
    // Detect edges by comparing the current input with the previous values
    anyedge <= ~in & shift_reg[7:0] | in & ~shift_reg[7:0];
end

endmodule