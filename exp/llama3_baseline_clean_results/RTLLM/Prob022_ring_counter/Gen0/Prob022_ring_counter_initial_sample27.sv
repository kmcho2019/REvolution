module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [7:0] next_state;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b0000_0001; // Initialize to starting state when reset is high
        end else begin
            // Shift the 1 in the current state to the next bit in the sequence
            next_state[0] = out[7];
            next_state[1] = out[0];
            next_state[2] = out[1];
            next_state[3] = out[2];
            next_state[4] = out[3];
            next_state[5] = out[4];
            next_state[6] = out[5];
            next_state[7] = out[6];

            out <= next_state; // Update the current state with the next state
        end
    end

endmodule