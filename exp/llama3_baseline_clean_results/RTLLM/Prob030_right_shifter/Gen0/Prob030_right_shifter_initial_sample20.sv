module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
    );

reg [7:0] q;  // Register to hold the shifted values

// Initialize the register q to 0
initial
    q = 8'b0;

// Perform the right shift operation on the rising edge of the clock
always @(posedge clk)
begin
    // Right shift the contents of q by 1 bit
    q <= {d, q[7:1]};
end

endmodule