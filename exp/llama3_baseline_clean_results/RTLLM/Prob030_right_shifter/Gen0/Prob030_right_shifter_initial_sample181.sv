module right_shifter(
    input clk,  // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q;  // Define an 8-bit register q

// Initialize the q register to 0
initial
    q = 8'b0;

// Procedural block to describe the synchronous behavior
always @ (posedge clk)
begin
    // Right shift the contents of q by 1 bit and insert d into the most significant position
    q = {d, q[7:1]};
end

endmodule