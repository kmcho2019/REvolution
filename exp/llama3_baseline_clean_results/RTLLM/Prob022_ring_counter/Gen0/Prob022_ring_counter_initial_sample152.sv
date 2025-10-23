module ring_counter(
    input clk,        // Clock signal
    input reset,      // Reset signal
    output reg [7:0] out // 8-bit output representing the current state
);

    // Define the initial state of the ring counter
    localparam INITIAL_STATE = 8'b0000_0001;

    // Always block to handle the clock and reset signals
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the counter to its initial state when reset is high
            out <= INITIAL_STATE;
        end else begin
            // Shift the set bit to the next position in the cyclic sequence
            out <= {out[6:0], out[7]};
        end
    end

endmodule