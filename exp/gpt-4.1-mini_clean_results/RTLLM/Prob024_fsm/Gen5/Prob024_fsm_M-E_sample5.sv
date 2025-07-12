module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding:
// S0: no bits matched
// S1: matched '1'
// S2: matched '10'
// S3: matched '100'
// S4: matched '1001'
typedef enum logic [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4
} state_t;

state_t state, next_state;

always @(*) begin
    case (state)
        S0: 
            if (IN) next_state = S1; // matched first '1'
            else next_state = S0;
        S1:
            if (~IN) next_state = S2; // matched '10'
            else next_state = S1; // input '1' again, stay matching first '1'
        S2:
            if (~IN) next_state = S3; // matched '100'
            else next_state = S1; // input '1' means restart at S1
        S3:
            if (IN) next_state = S4; // matched '1001'
            else next_state = S0; // mismatch, back to start
        S4:
            // After matching '1001', expecting last '1' of "10011"
            if (IN) next_state = S1; // completed pattern, loop start with '1'
            else next_state = S2; // got '0', partial restart
        default: next_state = S0;
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH asserted when the last input bit (IN=1) completes the sequence at state S4
        MATCH <= (state == S4) && (IN == 1'b1);
    end
end

endmodule