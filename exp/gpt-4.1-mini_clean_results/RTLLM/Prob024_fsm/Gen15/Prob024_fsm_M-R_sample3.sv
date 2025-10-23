module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // Binary state encoding (3-bit) for FSM states:
    // 0: S0 - initial state, no match
    // 1: S1 - matched '1'
    // 2: S2 - matched '10'
    // 3: S3 - matched '100'
    // 4: S4 - matched '1001'
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4;

    reg [2:0] state, next_state;

    // Next-state combinational logic using continuous assign
    // Defined in a function for clarity, then assigned to next_state
    function [2:0] calc_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                S0: calc_next_state = (in_bit) ? S1 : S0;
                S1: calc_next_state = (in_bit) ? S1 : S2;
                S2: calc_next_state = (in_bit) ? S1 : S3;
                S3: calc_next_state = (in_bit) ? S4 : S0;
                S4: calc_next_state = (in_bit) ? S1 : S2;
                default: calc_next_state = S0;
            endcase
        end
    endfunction

    // Continuous combinational assignment for next_state based on current state and input
    wire [2:0] next_state_wire = calc_next_state(state, IN);

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state_wire;
    end

    // Mealy output: MATCH is 1 when current state is S4 and input is 1
    assign MATCH = (state == S4) && IN;

endmodule