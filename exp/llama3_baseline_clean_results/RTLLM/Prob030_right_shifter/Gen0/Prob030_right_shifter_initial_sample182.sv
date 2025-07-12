module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal to be right-shifted
    output [7:0] q // Output signal representing the result of the right shift operation
);

reg [7:0] q; // Define q as an 8-bit register

initial q = 8'b0; // Initialize q to 0

always @(posedge clk) begin
    // On each rising edge of the clock, right shift q by one bit and insert d at the most significant position
    q <= {d, q[7:1]}; // This line achieves the desired operation in one step
end

endmodule