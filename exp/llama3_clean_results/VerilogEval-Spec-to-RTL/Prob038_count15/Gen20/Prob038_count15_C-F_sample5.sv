// Define a separate module for the counter to improve modularity
module Counter(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Increment the counter on every positive clock edge unless reset is high
always @(posedge clk) begin
    // Check for reset condition and reset counter to 0, or increment counter
    if (reset) 
        q <= 4'd0; // Reset counter to 0
    else 
        q <= q + 1'd1; // Increment counter
end

endmodule

// TopModule instantiates the Counter module
module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

// Instantiate the Counter module within TopModule
Counter counter_instance(
    .clk(clk),
    .reset(reset),
    .q(q)
);

endmodule