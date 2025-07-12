module fsm(
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

// State encoding
localparam S0 = 3'd0; // no match yet
localparam S1 = 3'd1; // matched '1'
localparam S2 = 3'd2; // matched '10'
localparam S3 = 3'd3; // matched '100'
localparam S4 = 3'd4; // matched '1001'

reg [2:0] state, next_state;

always @(*) begin
    // Default next state
    next_state = S0;
    MATCH = 1'b0;
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
            else // IN==1
                next_state = S1; // stay if another 1 (since the sequence starts with 1)
        end
        S2: begin
            if (IN == 1'b0)
                next_state = S3;
            else // IN==1
                next_state = S1; // restart partial match from 1
        end
        S3: begin
            if (IN == 1'b1)
                next_state = S4;
            else // IN==0
                next_state = S0;
        end
        S4: begin
            if (IN == 1'b1) begin
                next_state = S1;
                MATCH = 1'b1; // sequence "10011" matched
            end else if (IN == 1'b0) begin
                next_state = S2; // because input is 0 after '1001' matches so next partial is "10"
                MATCH = 1'b1;
            end else begin
                next_state = S0;
                MATCH = 1'b1;
            end
        end
        default: begin
            next_state = S0;
            MATCH = 1'b0;
        end
    endcase
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 1'b0;
    end else begin
        state <= next_state;
        // MATCH is combinational in always @(*), but Mealy FSM MATCH should be synchronous with input
        // So latch MATCH here to output register
        // MATCH updated below to keep Mealy behavior:
        // Actually, in Mealy FSM MATCH depends on current state and input, so keep combinational assignment
        // To achieve that, we use the combinational MATCH from always @(*) as next_MATCH.
        // So we move MATCH to be combinational outside or capture MATCH here:
        // For clarity, implement MATCH as combinational output from state and IN:

        // So better to remove the MATCH update here and instead assign it combinationally outside.

        // To fix, remove MATCH update here.
    end
end

// Because MATCH is Mealy output depending on current state and current input, assign it combinationally:
wire match_comb;
assign match_comb = (state == S4) && (IN == 1'b1);

// Drive output MATCH
always @(posedge CLK or posedge RST) begin
    if (RST)
        MATCH <= 1'b0;
    else
        MATCH <= match_comb;
end

endmodule