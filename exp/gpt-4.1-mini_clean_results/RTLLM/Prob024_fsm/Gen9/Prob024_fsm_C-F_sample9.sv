module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: number of bits matched so far for sequence "10011"
    localparam [2:0]
        S0 = 3'd0,  // no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Combinational next-state logic based on current state and input IN
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0; // start matching if IN=1
            S1: next_state = IN ? S1 : S2; // if IN=1 stay in S1 (could be start of new seq), else move to S2
            S2: next_state = IN ? S1 : S3; // if IN=1 restart at S1, else progress to S3
            S3: next_state = IN ? S4 : S0; // if IN=1 proceed to S4, else reset to S0
            S4: next_state = IN ? S1 : S2; // after match, if IN=1 restart at S1, else partial overlap S2
            default: next_state = S0;
        endcase
    end

    // Sequential logic: state update on rising clock edge with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output MATCH asserted immediately when state is S4 and input IN=1,
    // indicating sequence "10011" has just been matched
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule