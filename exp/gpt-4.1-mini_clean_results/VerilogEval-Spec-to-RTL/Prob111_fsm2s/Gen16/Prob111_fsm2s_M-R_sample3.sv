module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding using typedef enum for clarity
    typedef enum logic {OFF=1'b0, ON=1'b1} state_t;
    state_t state, next_state;

    // Next-state logic combinational function
    function state_t next_state_func(state_t curr_state, input logic j_in, input logic k_in);
        begin
            case (curr_state)
                OFF: next_state_func = j_in ? ON : OFF;
                ON:  next_state_func = k_in ? OFF : ON;
                default: next_state_func = OFF;
            endcase
        end
    endfunction

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state_func(state, j, k);
    end

    // Moore output is combinationally driven from current state
    assign out = (state == ON);

endmodule