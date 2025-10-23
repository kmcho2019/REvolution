module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0,  // no match yet
        S1 = 3'd1,  // matched '1'
        S2 = 3'd2,  // matched '10'
        S3 = 3'd3,  // matched '100'
        S4 = 3'd4,  // matched '1001'
        S5 = 3'd5;  // matched '10011' (final)

    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state = (IN) ? S1 : S0;
            S1: next_state = (IN) ? S1 : S2;
            S2: next_state = (IN) ? S1 : S3;
            S3: next_state = (IN) ? S4 : S0;
            S4: next_state = (IN) ? S5 : S2;
            S5: next_state = (IN) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is 1 only when next_state is S5 and input matches last '1' of the pattern
            MATCH <= (next_state == S5);
        end
    end

endmodule