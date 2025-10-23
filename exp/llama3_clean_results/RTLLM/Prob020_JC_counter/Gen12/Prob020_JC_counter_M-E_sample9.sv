// Module JC_counter: 64-bit Johnson counter using circular buffer approach
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Internal signal to store the least significant bit
reg lsb;

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    // Reset condition: set Q to 0
    if (!rst_n) Q <= 64'd0;
    // Normal operation: update Q based on its least significant bit
    else begin
        // Store the least significant bit
        lsb <= Q[0];
        
        // Shift the register to the right
        Q <= {~lsb, Q[63:1]};
    end
end

endmodule