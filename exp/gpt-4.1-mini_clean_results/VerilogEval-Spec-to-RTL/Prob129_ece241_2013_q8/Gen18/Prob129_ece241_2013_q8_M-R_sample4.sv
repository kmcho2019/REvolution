module TopModule (
    input  clk,
    input  aresetn,  // active low asynchronous reset (negative edge)
    input  x,
    output z
);

    // State encoding: 3 states for sequence "101" detection
    localparam [1:0]
        S0 = 2'b00,  // no bits matched yet
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10;  // matched "10"

    reg [1:0] state;

    // Next state combinational function
    function [1:0] next_state_func;
        input [1:0] current_state;
        input       input_x;
        begin
            case (current_state)
                S0: next_state_func = input_x ? S1 : S0;
                S1: next_state_func = input_x ? S1 : S2;
                S2: next_state_func = input_x ? S1 : S0;
                default: next_state_func = S0;
            endcase
        end
    endfunction

    wire [1:0] next_state = next_state_func(state, x);

    // Mealy output: asserted when in S2 and input x is 1
    assign z = (state == S2) && x;

    // State register with asynchronous negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule