module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Define the register q

// Initialize the register q to 0
initial
begin
    q = 8'b0;
end

// Perform the right shift operation on each rising edge of the clock
always @(posedge clk)
begin
    // Right shift the register q by 1 bit and insert the new input bit d into the most significant position
    q = {d, q[7:1]};
end

endmodule