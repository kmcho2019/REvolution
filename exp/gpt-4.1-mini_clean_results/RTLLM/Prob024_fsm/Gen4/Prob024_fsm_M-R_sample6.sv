module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // Define FSM states with an enumerated type (SystemVerilog style)
    // For pure Verilog-2001, we use parameters instead.
    localparam [2:0]
        S0 = 3'd0,  // no bits matched
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Function to determine next state given current state and input
    function [2:0] get_next_state;
        input [2:0] curr_state;
        input       in_bit;
        begin
            case (curr_state)
                S0: get_next_state = (in_bit == 1'b1) ? S1 : S0;
                S1: get_next_state = (in_bit == 1'b0) ? S2 : S1;
                S2: get_next_state = (in_bit == 1'b0) ? S3 : S1;
                S3: get_next_state = (in_bit == 1'b1) ? S4 : S0;
                S4: get_next_state = (in_bit == 1'b1) ? S1 : S2;
                default: get_next_state = S0;
            endcase
        end
    endfunction

    // Sequential logic: state update and MATCH output update at posedge CLK with synchronous reset
    always @(posedge CLK) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            next_state <= get_next_state(state, IN);
            state <= next_state;
            // MATCH is 1 if previous state is S4 and current IN==1 (Mealy output)
            MATCH <= (state == S4) && (IN == 1'b1);
        end
    end

endmodule