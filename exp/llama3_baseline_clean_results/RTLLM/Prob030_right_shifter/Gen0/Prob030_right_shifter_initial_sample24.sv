module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Initialize an 8-bit register

initial q = 8'd0;  // Initialize the register to 0

always @(posedge clk)  // Perform operation on the rising edge of the clock
begin
    q[7] = d;  // Assign the most significant bit the value of the input signal
    q[6:0] = q[7:1];  // Right shift the contents of the register by one bit
end

endmodule