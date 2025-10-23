module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

    // State encoding
    localparam [2:0]
        S0 = 3'd0, // initial state, no match
        S1 = 3'd1, // got first '1'
        S2 = 3'd2, // got '10'
        S3 = 3'd3, // got '100'
        S4 = 3'd4, // got '1001'
        S5 = 3'd5; // got '10011' (match state)

    reg [2:0] state, next_state;

    always @(*) begin
        // Default next state is current state
        next_state = S0;
        case (state)
            S0: next_state = (IN == 1'b1) ? S1 : S0;
            S1: next_state = (IN == 1'b0) ? S2 : S1;
            S2: next_state = (IN == 1'b0) ? S3 : S1;
            S3: next_state = (IN == 1'b1) ? S4 : S0;
            S4: next_state = (IN == 1'b1) ? S5 : S2;
            S5: next_state = (IN == 1'b0) ? S2 : S1;
            default: next_state = S0;
        endcase
    end

    // Sequential logic for state and output
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= S0;
            MATCH <= 1'b0;
        end else begin
            state <= next_state;
            // Mealy output: MATCH=1 when reaching S5, else 0
            MATCH <= (next_state == S5) ? 1'b1 : 1'b0;
        end
    end

endmodule