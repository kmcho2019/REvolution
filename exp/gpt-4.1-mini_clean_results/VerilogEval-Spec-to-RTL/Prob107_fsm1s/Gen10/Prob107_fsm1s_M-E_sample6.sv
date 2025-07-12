module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    typedef enum logic {B, A} state_t;
    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            case (state)
                B: begin
                    if (in == 1'b0)
                        next_state = A;
                    else
                        next_state = B;
                    out <= 1'b1;
                end
                A: begin
                    if (in == 1'b0)
                        next_state = B;
                    else
                        next_state = A;
                    out <= 1'b0;
                end
                default: begin
                    next_state = B;
                    out <= 1'b1;
                end
            endcase
            state <= next_state;
        end
    end

endmodule