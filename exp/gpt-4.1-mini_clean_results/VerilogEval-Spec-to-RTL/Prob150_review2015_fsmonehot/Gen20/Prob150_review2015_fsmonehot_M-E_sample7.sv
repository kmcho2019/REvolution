module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,       // one-hot: bit0=S ... bit9=Wait
    output reg         B3_next,
    output reg         S_next,
    output reg         S1_next,
    output reg         Count_next,
    output reg         Wait_next,
    output reg         done,
    output reg         counting,
    output reg         shift_ena
);

// State bit indices
localparam S_BIT     = 0;
localparam S1_BIT    = 1;
localparam S11_BIT   = 2;
localparam S110_BIT  = 3;
localparam B0_BIT    = 4;
localparam B1_BIT    = 5;
localparam B2_BIT    = 6;
localparam B3_BIT    = 7;
localparam COUNT_BIT = 8;
localparam WAIT_BIT  = 9;

always @(*) begin
    // Default assignments
    B3_next    = 1'b0;
    S_next     = 1'b0;
    S1_next    = 1'b0;
    Count_next = 1'b0;
    Wait_next  = 1'b0;
    done       = 1'b0;
    counting   = 1'b0;
    shift_ena  = 1'b0;

    // Identify current state and assign outputs and next states
    case (1'b1) // one-hot encoded, only one bit should be 1
        state[S_BIT]: begin
            // From S state
            // d=0 -> S; d=1 -> S1
            S_next  = (~d);
            S1_next = d;
        end
        state[S1_BIT]: begin
            // From S1 state
            // d=0 -> S; d=1 -> S11
            S_next  = (~d);
            S1_next = 1'b0;
            // S11 next state will be asserted below if needed
        end
        state[S11_BIT]: begin
            // From S11 state
            // d=0 -> S110; d=1 -> S11
            if (d) begin
                // Stay in S11
                S1_next = 1'b0;
                // S11 next is implied as stay, no output needed here (only S1_next and S_next outputs requested)
            end else begin
                // Move to S110 next state which is not an output port
                // So no output port asserted here
            end
            S_next = (~d);
        end
        state[S110_BIT]: begin
            // From S110 state
            // d=0 -> S; d=1 -> B0
            S_next  = (~d);
            // B0_next not requested as output, no assignment needed here
        end
        state[B0_BIT]: begin
            // B0 state: shift_ena=1, next -> B1 (not output)
            shift_ena = 1'b1;
        end
        state[B1_BIT]: begin
            // B1 state: shift_ena=1, next -> B2
            shift_ena = 1'b1;
        end
        state[B2_BIT]: begin
            // B2 state: shift_ena=1, next -> B3
            shift_ena = 1'b1;
        end
        state[B3_BIT]: begin
            // B3 state: shift_ena=1, next -> Count
            shift_ena = 1'b1;
            B3_next = 1'b1;
        end
        state[COUNT_BIT]: begin
            // Count state: counting=1
            counting = 1'b1;
            // done_counting=0 -> Count, done_counting=1 -> Wait
            Count_next = ~done_counting;
            Wait_next  = done_counting;
        end
        state[WAIT_BIT]: begin
            // Wait state: done=1
            done = 1'b1;
            // ack=0 -> Wait, ack=1 -> S
            Wait_next = ~ack;
            S_next    = ack;
        end
        default: begin
            // No state set or invalid state
            // All outputs remain zero
        end
    endcase
end

// S1_next needs to be asserted for S11 state transitions on d=1 and for S1 state on d=1
always @(*) begin
    // Explicitly assign S1_next for transitions involving S1 and S11 states
    if (state[S1_BIT] && d)
        S1_next = 1'b0; // actually goes to S11 which is not an output here
    else if (state[S11_BIT] && d)
        S1_next = 1'b0; // stays S11 again
    else if (state[S_BIT] && d)
        S1_next = 1'b1;
end

// For completeness, S_next and S1_next combined:
always @(*) begin
    if (state[S_BIT]) begin
        S_next  = ~d;
        S1_next = d;
    end else if (state[S1_BIT]) begin
        S_next  = ~d;
        S1_next = 1'b0;
    end else if (state[S11_BIT]) begin
        if (~d) begin
            S_next  = 1'b1; // move to S110 not output, but consider as S_next for safe default no output.
            S1_next = 1'b0;
        end else begin
            S_next  = 1'b0;
            S1_next = 1'b0;
        end
    end else if (state[WAIT_BIT]) begin
        S_next = ack;
    end else begin
        S_next  = 1'b0;
        S1_next = 1'b0;
    end
end

endmodule