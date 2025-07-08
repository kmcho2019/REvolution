module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

// State encoding
typedef enum logic [2:0] {
    S0 = 3'd0, // initial state
    S1 = 3'd1, // matched 1
    S2 = 3'd2, // matched 10
    S3 = 3'd3, // matched 100
    S4 = 3'd4  // matched 1001
} state_t;

state_t current_state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= S0;
    else
        current_state <= next_state;
end

// Next state and MATCH logic (Mealy output)
always @(*) begin
    MATCH = 1'b0;
    case (current_state)
        S0: begin
            if (IN)
                next_state = S1;
            else
                next_state = S0;
        end

        S1: begin
            if (~IN)
                next_state = S2;
            else
                // input=1 at S1 means sequence restart at 1
                next_state = S1;
        end

        S2: begin
            if (~IN)
                next_state = S3;
            else
                // IN=1 at S2 means partial overlap: sequence restart with 1
                next_state = S1;
        end

        S3: begin
            if (IN) begin
                next_state = S4;
            end else begin
                // input=0 at S3 means restart from S0 because sequence broken
                next_state = S0;
            end
        end

        S4: begin
            if (IN) begin
                // On input=1 at S4, sequence 10011 matched
                MATCH = 1'b1;
                // After match, because last bit is '1', next state is S1 (sequence restart)
                next_state = S1;
            end else begin
                // input=0 at S4, move to S2 because the sequence prefix for next detection is '10'
                next_state = S2;
            end
        end

        default: begin
            next_state = S0;
        end
    endcase
end

endmodule