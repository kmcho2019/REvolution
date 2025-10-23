module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

    // State encoding
    typedef enum logic [2:0] {
        S_RESET,
        S_0,
        S_1,
        S_2,
        S_3,
        S_4,
        S_5,
        S_6,
        S_ERR
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_RESET;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            S_RESET: next_state = in ? S_1 : S_0;
            S_0:     next_state = in ? S_1 : S_0;
            S_1:     next_state = in ? S_2 : S_0;
            S_2:     next_state = in ? S_3 : S_0;
            S_3:     next_state = in ? S_4 : S_0;
            S_4:     next_state = in ? S_5 : S_0;
            S_5:     next_state = in ? S_6 : S_0;
            S_6:     next_state = in ? S_ERR : S_0;
            S_ERR:   next_state = in ? S_ERR : S_0;
            default:  next_state = S_0;
        endcase
    end

    // Output logic (combinational)
    assign disc = (current_state == S_5) && !in;
    assign flag = (current_state == S_6) && !in;
    assign err  = (current_state == S_ERR);

endmodule