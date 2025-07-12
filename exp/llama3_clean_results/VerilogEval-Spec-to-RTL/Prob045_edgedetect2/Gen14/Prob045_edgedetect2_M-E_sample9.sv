module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] shift_reg;  // 8-bit shift register to capture the previous state

// Initialize the shift register to a known value at the start
initial begin
    shift_reg = 8'b0;
end

// Sequential logic to update the shift register
always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], in[7]};  // Shift in the new input value
end

// Continuous assignment for edge detection
assign anyedge = in ^ shift_reg;  // Detect edges

endmodule