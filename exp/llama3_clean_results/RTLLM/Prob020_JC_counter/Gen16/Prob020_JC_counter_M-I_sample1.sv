// Module JC_counter: 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Internal signal to store the most significant bit based on Q[0]
reg msb;

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 64'd0; // Reset condition
    end else begin
        // Determine the most significant bit based on Q[0]
        msb = ~Q[0];
        
        // Shift and append the MSB
        Q <= {msb, Q[63:1]};
    end
end

endmodule