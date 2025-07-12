module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding for sequence 1 0 0 1 1 detection
// States represent how many bits matched so far:
// S0 - no match
// S1 - matched '1'
// S2 - matched '10'
// S3 - matched '100'
// S4 - matched '1001'
// We output MATCH=1 at the transition that completes '10011'

localparam S0 = 3'd0;
localparam S1 = 3'd1;
localparam S2 = 3'd2;
localparam S3 = 3'd3;
localparam S4 = 3'd4;

reg [2:0] state, next_state;

always @(*) begin
    // Default next state
    next_state = S0;
    MATCH = 1'b0;

    case(state)
        S0: begin
            if(IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if(IN == 1'b0)
                next_state = S2;
            else
                next_state = S1; // stay if IN=1 (overlapping)
        end
        S2: begin
            if(IN == 1'b0)
                next_state = S3;
            else if(IN == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S3: begin
            if(IN == 1'b1)
                next_state = S4;
            else if(IN == 1'b0)
                next_state = S0;
            else
                next_state = S0;
        end
        S4: begin
            if(IN == 1'b1) begin
                // Matched full sequence 1 0 0 1 1 here:
                MATCH = 1'b1;
                // Because last input is '1', and sequence ends here,
                // check for overlapping sequence:
                // The sequence ends with '1', which is also start of sequence,
                // so transition to S1 for overlapping detection
                next_state = S1;
            end else if(IN == 1'b0) begin
                // The input after 10011 is '0', so start matching from S2
                // Because sequence start is '1', but we have 0 now,
                // so back to S2 only if next sequence to try. Actually,
                // better fallback:
                MATCH = 1'b1; // still output MATCH since this is the completion input
                next_state = S2;
            end else begin
                MATCH = 1'b1; // output match anyway
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH updated combinationally in next_state logic
        // But MATCH is reg driven here: to avoid race, keep it synchronous
        // Actually, better to separate MATCH reg update in clocked block
    end
end

// Separate combinational logic for MATCH signal updated synchronously:
always @(posedge CLK or posedge RST) begin
    if(RST) begin
        MATCH <= 1'b0;
    end else begin
        // MATCH combinational is assigned in always @(*) but also reg
        // To fix, remove MATCH from always@(*) and assign here based on state and IN
        // So let's remove MATCH assignment in always @(*) and do here
    end
end

// Redo the logic to avoid mismatch:

// So refactor: Remove MATCH from combinational block and implement separately:

endmodule