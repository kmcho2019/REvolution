module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// Binary encoded states for sequence "10011":
// S0: no match yet
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

// Combinational logic to determine next state and match output
// MATCH is a Mealy output, asserted when last input bit matches final state transition
wire match_next;

always @(*) begin
    next_state = state; // default hold state
    case (state)
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
                next_state = S1; // stay if IN=1 again (partial repeat)
        end
        S2: begin
            if (~IN)
                next_state = S3;
            else
                next_state = S1;
        end
        S3: begin
            if (IN)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN)
                next_state = S1;  // loop detection for overlapping sequences
            else
                next_state = S2;
        end
        default: next_state = S0;
    endcase
end

// MATCH assertion combinational logic (Mealy output)
// MATCH is high only when in S4 and input is 1 (detecting '10011' sequence)
assign match_next = (state == S4) && (IN == 1'b1);

// State and output registers
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        MATCH <= match_next;
    end
end

endmodule