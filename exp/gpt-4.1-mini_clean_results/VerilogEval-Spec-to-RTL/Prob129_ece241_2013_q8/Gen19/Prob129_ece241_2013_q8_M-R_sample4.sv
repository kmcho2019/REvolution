module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding: minimal 2-bit for 3 states
    localparam S0 = 2'b00; // no bits matched yet
    localparam S1 = 2'b01; // matched '1'
    localparam S2 = 2'b10; // matched "10"

    reg [1:0] state, state_next;

    // Next-state logic function
    function [1:0] next_state_func;
        input [1:0] curr_state;
        input       curr_x;
        begin
            case (curr_state)
                S0: next_state_func = curr_x ? S1 : S0;
                S1: next_state_func = curr_x ? S1 : S2;
                S2: next_state_func = curr_x ? S1 : S0;
                default: next_state_func = S0;
            endcase
        end
    endfunction

    // Compute next state combinationally
    always @(*) begin
        state_next = next_state_func(state, x);
    end

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= state_next;
    end

    // Output z asserted when in S2 and input x = 1 (Mealy output)
    assign z = (state == S2) && x;

endmodule