module right_shifter(
    input clk, // Clock signal
    input d,   // Input signal
    output [7:0] q  // Output signal
);

reg [7:0] q; // Define the register q

// Initialize the register q to 0
initial begin
    q = 8'b0; // Initialize q to 0
end

// Right shift the register q on each rising edge of the clock
always @ (posedge clk) begin
    q = {d, q[7:1]}; // Right shift the register and insert the new input bit
end

endmodule