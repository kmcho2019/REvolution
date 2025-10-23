module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding:
    // Represents how many bits of "10011" have been matched so far
    // 0: no match
    // 1: matched '1'
    // 2: matched '10'
    // 3: matched '100'
    // 4: matched '1001'
    reg [2:0] state, next_state;

    // Combinational block for next-state logic with clear case structure
    always @(*) begin
        case (state)
            3'd0: next_state = (IN == 1'b1) ? 3'd1 : 3'd0;

            3'd1: next_state = (IN == 1'b0) ? 3'd2 : 3'd1;

            3'd2: next_state = (IN == 1'b0) ? 3'd3 : 3'd1;

            3'd3: next_state = (IN == 1'b1) ? 3'd4 : 3'd0;

            3'd4: next_state = (IN == 1'b1) ? 3'd1 : 3'd2;

            default: next_state = 3'd0;
        endcase
    end

    // Sequential logic: state update on rising edge of CLK, synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= 3'd0;
        else
            state <= next_state;
    end

    // Mealy output: assert MATCH when FSM is in state 4 and input IN=1 (final bit of "10011")
    assign MATCH = (state == 3'd4) && (IN == 1'b1);

endmodule