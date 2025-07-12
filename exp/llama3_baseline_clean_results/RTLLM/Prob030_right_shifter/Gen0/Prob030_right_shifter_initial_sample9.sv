module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define the 8-bit register q

initial
    q = 8'b0;  // Initialize q to 0

always @ (posedge clk)  // Capture the rising edge of the clock signal
begin
    // Right shift the contents of the q register by one bit and insert the new input bit d into the most significant position of the register
    q <= {d, q[7:1]};
end

endmodule