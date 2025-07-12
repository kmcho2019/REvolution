module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // States encoding: number of matched bits of "10011"
    typedef enum reg [2:0] {
        S0 = 3'd0, // no match
        S1 = 3'd1, // matched '1'
        S2 = 3'd2, // matched '10'
        S3 = 3'd3, // matched '100'
        S4 = 3'd4, // matched '1001'
        S5 = 3'd5  // matched '10011' (final, actually never latched because Mealy)
    } state_t;

    state_t current_state, next_state;

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S1 : S2; // overlap handling
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state update and MATCH generation
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            MATCH <= 1'b0;
        end else begin
            // Mealy output: MATCH is 1 when in S4 and IN==1 (completing "10011")
            MATCH <= (current_state == S4) && (IN == 1'b1);
            current_state <= next_state;
        end
    end

endmodule