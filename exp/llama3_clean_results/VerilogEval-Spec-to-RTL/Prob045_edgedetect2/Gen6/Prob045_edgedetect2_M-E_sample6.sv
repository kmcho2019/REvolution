module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [15:0] shift_reg;  // 16-bit shift register to store current and previous states

// Initialize the shift register
initial begin
    shift_reg = 16'b0;
end

// Sequential logic to update the shift register and detect edges
always @(posedge clk) begin
    // Shift the current state to the lower half and load the new input into the upper half
    shift_reg <= {in, shift_reg[15:8]};
    
    // Detect edges by comparing corresponding bits in the upper and lower halves
    anyedge <= shift_reg[15:8] ^ shift_reg[7:0];
end

endmodule