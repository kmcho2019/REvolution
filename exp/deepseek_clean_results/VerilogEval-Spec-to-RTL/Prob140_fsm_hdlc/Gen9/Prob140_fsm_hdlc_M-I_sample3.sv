module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] state;  // One-hot encoded states (0-6 consecutive 1s)
    reg error_flag;    // Sticky error flag

    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b0000001;  // Reset to state 0 (LSB represents zero 1s)
            error_flag <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transition logic
            if (in && !error_flag) begin
                if (state[5]) begin  // After 5 consecutive 1s
                    state <= 7'b1000000;  // Move to state 6
                end else begin
                    state <= {state[5:0], 1'b0};  // Shift left
                end
            end else if (!in) begin
                // Check for conditions on zero input
                if (state[6]) begin      // 6 consecutive 1s
                    flag <= 1;
                end else if (state[5]) begin  // 5 consecutive 1s
                    disc <= 1;
                end
                state <= 7'b0000001;    // Reset to state 0
                error_flag <= 0;
            end

            // Error detection (7+ consecutive 1s)
            if (state[6] && in) begin
                error_flag <= 1;
                err <= 1;
            end else if (error_flag && in) begin
                err <= 1;
            end
        end
    end

endmodule