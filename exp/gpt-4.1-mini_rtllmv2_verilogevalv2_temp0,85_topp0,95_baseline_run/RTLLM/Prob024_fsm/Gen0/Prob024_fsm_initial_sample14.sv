module fsm (
    input  wire IN,
    input  wire CLK,
    input  wire RST,
    output reg  MATCH
);

// State encoding for detecting sequence 1 0 0 1 1
// State definitions:
// S0: initial state, no bits matched
// S1: matched '1'
// S2: matched '10'
// S3: matched '100'
// S4: matched '1001'
// Transition to next states according to input
// On final '1' in '10011', MATCH=1

typedef enum reg [2:0] {
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4
} state_t;

state_t state, next_state;

always @(*) begin
    MATCH = 1'b0; // default
    case(state)
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
                next_state = S1; // stay if input 1 (possible new sequence)
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else
                next_state = S1; // restart sequence with new '1'
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1) begin
                // Full sequence matched: 1 0 0 1 1
                MATCH = 1'b1;
                // After MATCH, next state depends on IN to support overlap:
                // For input '1' after match, stay in S1 (start detecting new sequence)
                next_state = S1;
            end else begin
                // If input zero, partial match restarts or back to S2 for second zero
                next_state = S2; 
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH is combinational from above always block and will be updated accordingly
        // To make MATCH a registered output, update it here:
        // But since MATCH is combinational and depends on state and input,
        // We assign MATCH here as well for synchronous output.
        // To align with Mealy behavior, MATCH is updated combinationally.
        // So just keep combinational assignment.
        // However, since MATCH is reg, and combinational block assigns it,
        // We must disable the sequential assignment here.
        // So no assignment in sequential block to MATCH.
    end
end

endmodule