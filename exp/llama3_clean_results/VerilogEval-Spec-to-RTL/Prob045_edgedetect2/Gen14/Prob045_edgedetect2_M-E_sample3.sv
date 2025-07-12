module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] shift_reg;  // Shift register to store the previous state

// Initialize the shift register to a known value at the start
initial begin
    shift_reg = 8'b0;
end

// Sequential logic to update the shift register
always @(posedge clk) begin
    shift_reg <= {in, shift_reg[7:1]};  // Shift the register and insert the new input
end

// Continuous assignment for edge detection
assign anyedge = in ^ shift_reg;  // Detect edges

endmodule