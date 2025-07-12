module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output data
);

// Initialize the output to a default value to ensure it's defined at the start of simulation
initial q = 0;

// Always block triggered on the positive edge of the clock
always @(posedge clk)
    // Non-blocking assignment is used for sequential logic
    q <= d; // Assign input d to output q on the positive clock edge

endmodule