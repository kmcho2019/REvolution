module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define the register q

initial q = 8'b0;  // Initialize q to 0

always @ (posedge clk)  // On each rising edge of the clock
begin
    q[7] = d;  // Assign the input signal d to the most significant bit of q
    q[6:0] = q[7:1];  // Right shift the contents of q by one bit
end

endmodule