// Parameterizable LFSR module
module LFSR #
(
    parameter SIZE = 4  // Size of the LFSR
)
(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [SIZE-1:0] out  // Output representing the current state of the LFSR
);

// Internal signal for feedback calculation
reg [SIZE-1:0] state;

// Always block for sequential logic
always @(posedge clk) begin
    if (rst) begin // Reset condition: initialize state to zero
        state <= {SIZE{1'b0}};
    end else begin // Normal operation: update LFSR state
        // Calculate feedback (XOR of most significant and second most significant bits)
        reg feedback;
        feedback = ~(state[SIZE-1] ^ state[SIZE-2]);
        
        // Shift the bits in the LFSR and insert the new feedback value
        state <= {state[SIZE-2:0], feedback};
    end
end

// Continuous assignment to output
assign out = state;

endmodule