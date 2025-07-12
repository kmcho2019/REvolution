module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [6:0] state;  // One-hot state: bit N represents N+1 consecutive 1s

    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b0000001;  // Reset to "0 received" state (bit 0)
            {disc, flag, err} <= 3'b000;
        end else begin
            // Default outputs (only clear when needed)
            disc <= 0;
            flag <= 0;
            err <= 0;

            if (in) begin
                // Gray-code like state progression to minimize bit toggles
                case (1'b1)
                    state[0]: state <= 7'b0000010;
                    state[1]: state <= 7'b0000100;
                    state[2]: state <= 7'b0001000;
                    state[3]: state <= 7'b0010000;
                    state[4]: state <= 7'b0100000;
                    state[5]: state <= 7'b1000000;
                    state[6]: begin
                        state <= 7'b1000000;  // Stay in error state
                        err <= 1;
                    end
                    default: state <= 7'b0000001;
                endcase
            end else begin
                // Generate outputs based on current state
                case (1'b1)
                    state[5]: disc <= 1;
                    state[6]: flag <= 1;
                    default: ;  // No outputs for other states
                endcase
                state <= 7'b0000001;  // Reset to initial state
            end
        end
    end

endmodule