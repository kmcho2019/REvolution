module JC_counter (
    input clk,        // Clock input
    input rst_n,      // Active-low reset
    output reg [63:0] Q  // 64-bit counter output
);

// Johnson counter implementation:
// Circular shift with inverted feedback (LSB)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        Q <= 64'b0;          // Async reset
    else 
        Q <= {~Q[0], Q[63:1]}; // Shift with inverted feedback
end

endmodule