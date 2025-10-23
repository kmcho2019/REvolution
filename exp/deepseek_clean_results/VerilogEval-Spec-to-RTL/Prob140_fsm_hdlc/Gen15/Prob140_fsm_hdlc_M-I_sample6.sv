module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (s0-s7)
    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001;  // s0 (count=0)
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs (only set when conditions met)
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            if (in) begin
                if (~state[7]) begin  // Not in error state yet
                    state <= {state[6:0], 1'b0};  // Shift left
                end
            end else begin
                // Check for special conditions on 0 input
                disc <= state[5];  // 5 consecutive 1s
                flag <= state[6];  // 6 consecutive 1s
                err <= state[7];  // 7+ consecutive 1s
                state <= 8'b00000001;  // Reset to s0
            end
        end
    end

endmodule