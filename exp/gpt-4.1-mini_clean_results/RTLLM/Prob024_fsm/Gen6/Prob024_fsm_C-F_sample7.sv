module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding: how many bits matched so far
    localparam [2:0]
        S0 = 3'd0,  // no match
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S1 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output MATCH asserted when state is S4 and current input IN = 1
    // This means the sequence "10011" has just been completed
    assign MATCH = (state == S4) && (IN == 1'b1);

endmodule