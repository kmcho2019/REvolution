module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // FSM state encoding: matched prefix length of "10011"
    // States:
    // 0 - no match
    // 1 - matched '1'
    // 2 - matched '10'
    // 3 - matched '100'
    // 4 - matched '1001' (expecting last '1')
    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            3'd0: 
                next_state = (IN == 1'b1) ? 3'd1 : 3'd0;

            3'd1: 
                next_state = (IN == 1'b0) ? 3'd2 : 3'd1;

            3'd2: 
                next_state = (IN == 1'b0) ? 3'd3 : 3'd1;

            3'd3: 
                next_state = (IN == 1'b1) ? 3'd4 : 3'd0;

            3'd4: 
                // After detecting '1001', on IN=1 the sequence '1' can restart detection (state 1),
                // on IN=0 it matches prefix '10' (state 2), supporting overlap.
                next_state = (IN == 1'b1) ? 3'd1 : 3'd2;

            default: 
                next_state = 3'd0;
        endcase
    end

    // State update with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: MATCH asserted when in state 4 and IN=1 (last bit of "10011")
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule