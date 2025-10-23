module TopModule (
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,         // one-hot current state
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

    // State bit indices for readability
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

    // Current states
    wire S     = state[S_BIT];
    wire S1    = state[S1_BIT];
    wire S11   = state[S11_BIT];
    wire S110  = state[S110_BIT];
    wire B0    = state[B0_BIT];
    wire B1    = state[B1_BIT];
    wire B2    = state[B2_BIT];
    wire B3    = state[B3_BIT];
    wire COUNT = state[COUNT_BIT];
    wire WAIT  = state[WAIT_BIT];

    // Initialize next_state vector with all zeros
    reg [9:0] next_state;

    always @(*) begin
        // Default: no next state active (should never happen in one-hot FSM)
        next_state = 10'b0;

        // State transitions per problem description
        if (S) begin
            if (d == 1'b0)
                next_state[S_BIT] = 1'b1;    // stay in S
            else
                next_state[S1_BIT] = 1'b1;
        end
        else if (S1) begin
            if (d == 1'b0)
                next_state[S_BIT] = 1'b1;
            else
                next_state[S11_BIT] = 1'b1;
        end
        else if (S11) begin
            if (d == 1'b0)
                next_state[S110_BIT] = 1'b1;
            else
                next_state[S11_BIT] = 1'b1;  // stay in S11 if d=1
        end
        else if (S110) begin
            if (d == 1'b0)
                next_state[S_BIT] = 1'b1;
            else
                next_state[B0_BIT] = 1'b1;
        end
        else if (B0) begin
            next_state[B1_BIT] = 1'b1;
        end
        else if (B1) begin
            next_state[B2_BIT] = 1'b1;
        end
        else if (B2) begin
            next_state[B3_BIT] = 1'b1;
        end
        else if (B3) begin
            next_state[COUNT_BIT] = 1'b1;
        end
        else if (COUNT) begin
            if (done_counting == 1'b0)
                next_state[COUNT_BIT] = 1'b1;
            else
                next_state[WAIT_BIT] = 1'b1;
        end
        else if (WAIT) begin
            if (ack == 1'b0)
                next_state[WAIT_BIT] = 1'b1;
            else
                next_state[S_BIT] = 1'b1;
        end
        else begin
            // In case of illegal state, default to S
            next_state[S_BIT] = 1'b1;
        end
    end

    // Assign outputs based on next_state and current state
    assign B3_next    = next_state[B3_BIT];
    assign S_next     = next_state[S_BIT];
    assign S1_next    = next_state[S1_BIT];
    assign Count_next = next_state[COUNT_BIT];
    assign Wait_next  = next_state[WAIT_BIT];

    // Moore outputs depend on current state
    assign done      = WAIT;
    assign counting  = COUNT;
    assign shift_ena = B0 | B1 | B2 | B3;

endmodule