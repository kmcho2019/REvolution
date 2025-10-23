module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding with parameters for clarity
    localparam IDLE  = 3'd0;
    localparam S1    = 3'd1; // matched '1'
    localparam S10   = 3'd2; // matched '10'
    localparam S100  = 3'd3; // matched '100'
    localparam S1001 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic implemented with continuous assignment inside a function
    function [2:0] calc_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                IDLE:    calc_next_state = (in_bit) ? S1 : IDLE;
                S1:      calc_next_state = (in_bit) ? S1 : S10;
                S10:     calc_next_state = (in_bit) ? S1 : S100;
                S100:    calc_next_state = (in_bit) ? S1001 : IDLE;
                S1001:   calc_next_state = (in_bit) ? S1 : S10;
                default: calc_next_state = IDLE;
            endcase
        end
    endfunction

    // Compute next_state combinationally with assign, depending on current state and input
    wire [2:0] next_state_w = calc_next_state(state, IN);

    // Synchronous state update
    always @(posedge CLK) begin
        if (RST)
            state <= IDLE;
        else
            state <= next_state_w;
    end

    // Mealy output: MATCH asserted when current state is S1001 and input IN=1 completes the sequence
    assign MATCH = (state == S1001) && IN;

endmodule