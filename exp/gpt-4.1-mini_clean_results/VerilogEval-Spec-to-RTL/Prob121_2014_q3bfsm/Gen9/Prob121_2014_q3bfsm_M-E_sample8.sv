module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t state, next_state;

    // Next state function
    function state_t nextState(state_t curr, input logic in);
        case (curr)
            S0: nextState = (in) ? S1 : S0;
            S1: nextState = (in) ? S4 : S1;
            S2: nextState = (in) ? S1 : S2;
            S3: nextState = (in) ? S2 : S1;
            S4: nextState = (in) ? S4 : S3;
            default: nextState = S0;
        endcase
    endfunction

    // Output function
    function logic outputZ(state_t curr);
        outputZ = (curr == S3) || (curr == S4);
    endfunction

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= nextState(state, x);
    end

    always @(*) begin
        z = outputZ(state);
    end

endmodule