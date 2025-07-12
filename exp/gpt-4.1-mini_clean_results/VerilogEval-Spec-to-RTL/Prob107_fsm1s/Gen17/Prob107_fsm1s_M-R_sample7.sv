module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    typedef enum logic {B = 1'b0, A = 1'b1} state_t;
    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // State and output register update (synchronous active-high reset)
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            state <= next_state;
            // Output depends only on current state (Moore)
            out <= (state == B) ? 1'b1 : 1'b0;
        end
    end

endmodule