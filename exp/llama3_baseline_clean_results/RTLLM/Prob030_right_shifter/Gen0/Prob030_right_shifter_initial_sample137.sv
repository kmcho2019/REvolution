module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Define the register q

initial // Initialize the register q to 0
    q = 8'b0;

always @ (posedge clk) // On each rising edge of the clock
begin
    // Right shift the contents of q by 1 bit and insert the new input bit d into the most significant position
    q = {d, q[7:1]}; // This operation shifts q to the right and assigns d to q[7]
end

endmodule