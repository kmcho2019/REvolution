module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // Use typedef enum for state encoding
    typedef enum logic {OFF=1'b0, ON=1'b1} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            case(state)
                OFF: begin
                    if (j)
                        state <= ON;
                    else
                        state <= OFF;
                end
                ON: begin
                    if (k)
                        state <= OFF;
                    else
                        state <= ON;
                end
                default: state <= OFF;
            endcase

            // Output follows current registered state (Moore)
            out <= (state == ON) ? 1'b1 : 1'b0;
        end
    end

endmodule