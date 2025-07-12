module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // State encoding using parameters for simplicity
    localparam [1:0]
        S0 = 2'b00,  // no bits matched
        S1 = 2'b01,  // matched '1'
        S2 = 2'b10;  // matched "10"

    reg [1:0] state, next_state;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic as a combinational function
    function [1:0] f_next_state(input [1:0] curr_state, input in_x);
        begin
            case (curr_state)
                S0: f_next_state = in_x ? S1 : S0;
                S1: f_next_state = (~in_x) ? S2 : S1;
                S2: f_next_state = in_x ? S1 : S0;
                default: f_next_state = S0;
            endcase
        end
    endfunction

    // Combinational always block to update next_state using the function
    always @(*) begin
        next_state = f_next_state(state, x);
    end

    // Output z asserted when in state S2 and input x is 1, indicating "101" detected
    assign z = (state == S2) && x;

endmodule