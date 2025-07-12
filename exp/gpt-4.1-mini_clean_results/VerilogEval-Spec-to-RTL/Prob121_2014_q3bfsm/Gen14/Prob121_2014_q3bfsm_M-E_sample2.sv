module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // Enumerated states for clarity
    typedef enum logic [2:0] {
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            // State transitions based on current state and input x
            case (state)
                S0: begin
                    state <= x ? S1 : S0;
                    z <= 1'b0;
                end
                S1: begin
                    state <= x ? S4 : S1;
                    z <= 1'b0;
                end
                S2: begin
                    state <= x ? S1 : S2;
                    z <= 1'b0;
                end
                S3: begin
                    state <= x ? S2 : S1;
                    z <= 1'b1;
                end
                S4: begin
                    state <= x ? S4 : S3;
                    z <= 1'b1;
                end
                default: begin
                    state <= S0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule