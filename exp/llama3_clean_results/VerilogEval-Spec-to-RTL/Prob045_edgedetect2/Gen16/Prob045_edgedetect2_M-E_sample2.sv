module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] shift_reg;  // Shift register to store the previous input vector

// Initialize the shift register to a known value at the start
initial begin
    shift_reg = 8'b0;
end

// Sequential logic to update the shift register
always @(posedge clk) begin
    shift_reg <= in;  // Shift in the current input vector
end

// Continuous assignment for edge detection using XOR
assign anyedge = in ^ shift_reg;  // Detect edges by comparing current and previous input vectors

endmodule