module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Define a variable to hold the next state of the counter
reg [3:0] next_q;

// Combinational logic to determine the next state
always @(*) begin
    if (reset) 
        next_q = 0; // Reset counter to 0
    else 
        next_q = q + 1; // Increment counter
end

// Sequential logic to update the counter state on the positive clock edge
always @(posedge clk) begin
    q <= next_q; // Update the counter state
end

endmodule