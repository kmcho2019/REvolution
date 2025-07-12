module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output wire MATCH
);

    // State encoding for sequence detection "10011"
    localparam [2:0]
        S0 = 3'd0,  // initial state, no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4;  // matched '1001'

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;   // On '1' go to S1, else stay
            S1: next_state = IN ? S1 : S2;   // On '1' stay S1 (multiple leading 1's), on '0' go S2
            S2: next_state = IN ? S1 : S3;   // On '1' restart from S1, on '0' go S3
            S3: next_state = IN ? S4 : S0;   // On '1' go S4, else restart S0
            S4: next_state = IN ? S1 : S2;   // On '1' restart S1 (overlap), on '0' go S2
            default: next_state = S0;
        endcase
    end

    // State update on clock, synchronous reset
    always @(posedge CLK) begin
        if (RST)
            state <= S0;
        else
            state <= next_state;
    end

    // Mealy output combinational: assert MATCH when in S4 and IN=1 (last input '1' completes "10011")
    assign MATCH = (state == S4) && IN;

endmodule