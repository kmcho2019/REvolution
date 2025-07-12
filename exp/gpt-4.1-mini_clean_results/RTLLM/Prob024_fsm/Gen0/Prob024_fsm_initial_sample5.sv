module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding
// S0: initial state, waiting for '1'
// S1: got '1'
// S2: got '10'
// S3: got '100'
// S4: got '1001'
// We detect '10011' sequence, output MATCH=1 at last '1'

typedef enum reg [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4
} state_t;

reg [2:0] state, next_state;

always @(*) begin
    // Default values
    next_state = S0;
    MATCH = 0;
    case (state)
        S0: begin
            if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (IN == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else if (IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1) begin
                // Detected full sequence 10011 here, MATCH=1
                next_state = S1; 
                MATCH = 1'b1;
            end else if (IN == 1'b0) begin
                next_state = S2;
                MATCH = 1'b1;
            end else begin
                next_state = S0;
                MATCH = 1'b1;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 0;
        end
    endcase

    // Special case: MATCH only asserted when final input is 1 (last bit of sequence)
    // According to problem, MATCH=1 only at last '1' of sequence
    // So only assert MATCH when next_state=S1 on last 1 input from S4
    if (state == S4 && IN == 1'b1)
        MATCH = 1'b1;
    else
        MATCH = 0;
end

// State register
always @(posedge CLK or posedge RST) begin
    if (RST)
        state <= S0;
    else
        state <= next_state;
end

endmodule