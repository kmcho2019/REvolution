module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for clarity and easy modification
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Function for next_state combinational logic with case statement
    function automatic logic get_next_state(input logic curr_state, input logic j_in, input logic k_in);
        case (curr_state)
            OFF: get_next_state = j_in ? ON : OFF;
            ON:  get_next_state = k_in ? OFF : ON;
            default: get_next_state = OFF;
        endcase
    endfunction

    // Next state calculated combinationally
    wire next_state = get_next_state(state, j, k);

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output driven directly from current state
    assign out = state;

endmodule