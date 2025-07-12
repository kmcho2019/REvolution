module right_shifter (
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define the q register as an 8-bit register

initial q = 8'b0;  // Initialize the q register to 0

always @ (posedge clk)  // Sequential block triggered on the rising edge of the clock
begin
    q = (q >> 1);  // Right-shift the q register by 1 bit
    q[7] = d;  // Insert the new input bit d into the most significant position of the register
end

endmodule