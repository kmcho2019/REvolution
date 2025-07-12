module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // One-hot encoded states for pattern matching
    // Each bit represents progress in matching the sequence
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b0001;  // Initial state (no match progress)
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            // Parallel state transitions:
            // state[0]: always active (looking for first '1')
            // state[1]: matched '1' and looking for '1'
            // state[2]: matched '11' and looking for '0'
            // state[3]: matched '110' and looking for '1'
            state[0] <= 1'b1;  // Always looking for new pattern start
            state[1] <= state[0] & data;
            state[2] <= state[1] & data;
            state[3] <= state[2] & ~data;

            // Pattern matched when we reach state[3] and see '1'
            start_shifting <= state[3] & data;
        end
    end

endmodule