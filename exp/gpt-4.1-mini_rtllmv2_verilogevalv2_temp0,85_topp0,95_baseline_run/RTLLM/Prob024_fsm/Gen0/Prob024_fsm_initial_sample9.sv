module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding
typedef enum logic [2:0] {
    S0 = 3'd0, // no match yet
    S1 = 3'd1, // matched 1
    S2 = 3'd2, // matched 1,0
    S3 = 3'd3, // matched 1,0,0
    S4 = 3'd4  // matched 1,0,0,1
} state_t;

state_t current_state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST)
        current_state <= S0;
    else
        current_state <= next_state;
end

always @(*) begin
    MATCH = 0;
    case (current_state)
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
                next_state = S1; // if input is 1, stay in S1 because sequence starts with 1
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else if (IN == 1'b1)
                next_state = S1; // restart because sequence starts with 1
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
            // On input=1, output MATCH=1 (sequence complete)
            if (IN == 1'b1) begin
                MATCH = 1'b1;
                // After matching 1,0,0,1,1 we need to check overlap:
                // The last '1' can also be start of a new sequence
                next_state = S1;
            end else if (IN == 1'b0) begin
                MATCH = 1'b0;
                next_state = S2; // Because input=0 after last '1', this matches the second element of sequence after starting at S1
            end else begin
                MATCH = 1'b0;
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 0;
        end
    endcase
end

endmodule