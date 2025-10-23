module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [15:0] shift_reg; // Shift register to store the last two input vectors

// Initialize the shift register to a known value at the start
initial begin
    shift_reg = 16'b0;
end

// Sequential logic to shift in the new input vector
always @(posedge clk) begin
    shift_reg <= {in, shift_reg[7:0]}; // Shift in the new input vector
end

// Continuous assignment for edge detection
assign anyedge = shift_reg[7:0] ^ shift_reg[15:8]; // Detect edges

endmodule