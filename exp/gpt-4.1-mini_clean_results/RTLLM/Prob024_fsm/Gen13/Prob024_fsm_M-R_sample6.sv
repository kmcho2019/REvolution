module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding representing matched prefix lengths:
    localparam [2:0]
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Function to compute next state given current state and input
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

    // Combinational next state assignment
    always @(*) begin
        next_state = get_next_state(state, IN);
    end

    // Sequential state update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore output logic: MATCH asserted when in S4 and input bit was '1' in previous cycle
    // Since output is registered, MATCH is high when state is S4 (pattern detected)
    always @(posedge CLK) begin
        if (RST)
            MATCH <= 1'b0;
        else
            MATCH <= (state == S4);
    end

endmodule