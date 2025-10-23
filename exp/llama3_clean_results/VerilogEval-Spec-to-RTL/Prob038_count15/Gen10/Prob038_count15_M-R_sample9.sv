module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

reg [3:0] next_q; // Next state of the counter

// Combinational logic to calculate the next state
always @(*) begin
    if (reset)
        next_q = 4'd0; // Reset counter to 0
    else if (q == 4'd15)
        next_q = 4'd0; // Wrap around from 15 to 0
    else
        next_q = q + 1'd1; // Increment counter
end

// Sequential logic to update the counter on positive clock edges
always @(posedge clk) begin
    q <= next_q; // Update the counter
end

endmodule