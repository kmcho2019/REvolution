module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding - count of consecutive 1s (0-6) plus error state (7)
    reg [2:0] state;
    reg next_disc, next_flag, next_err;

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Register the outputs with 1-cycle delay
            disc <= next_disc;
            flag <= next_flag;
            err <= next_err;

            // Default outputs for next cycle
            next_disc <= 0;
            next_flag <= 0;
            next_err <= 0;

            // State transitions
            case (state)
                0: begin
                    if (in) state <= 1;
                    else state <= 0;
                end
                1: begin
                    if (in) state <= 2;
                    else state <= 0;
                end
                2: begin
                    if (in) state <= 3;
                    else state <= 0;
                end
                3: begin
                    if (in) state <= 4;
                    else state <= 0;
                end
                4: begin
                    if (in) state <= 5;
                    else state <= 0;
                end
                5: begin
                    if (in) state <= 6;
                    else begin
                        state <= 0;
                        next_disc <= 1;  // Will be registered next cycle
                    end
                end
                6: begin
                    if (in) state <= 7;
                    else begin
                        state <= 0;
                        next_flag <= 1;  // Will be registered next cycle
                    end
                end
                7: begin
                    if (in) next_err <= 1;  // Continuous error while in state 7
                    else state <= 0;
                end
            endcase
        end
    end

endmodule