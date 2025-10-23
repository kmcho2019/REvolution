module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Declare an 8-bit register and initialize to 0
initial q = 8'd0;  // Initialize the register to 0

always @ (posedge clk)  // Trigger on the rising edge of the clock
begin
    q <= (q >> 1);  // Right shift the register by 1 bit
    q[7] <= d;  // Assign the new input bit to the most significant bit
end

endmodule