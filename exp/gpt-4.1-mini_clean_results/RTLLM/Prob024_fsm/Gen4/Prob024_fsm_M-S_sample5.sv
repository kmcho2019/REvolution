module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding (3 bits for 6 states)
    localparam [2:0]
        S0 = 3'd0,
        S1 = 3'd1,
        S2 = 3'd2,
        S3 = 3'd3,
        S4 = 3'd4,
        S5 = 3'd5;

    reg [2:0] state, next_state;

    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S1 : S3;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S5 : S2;
            S5: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // MATCH is asserted when the FSM moves into S5 (sequence detected)
            // That occurs when current state is S4 and IN=1 causes transition to S5
            MATCH <= (state == S4) && IN;
        end
    end

endmodule