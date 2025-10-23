module TopModule(
    input  wire        d,
    input  wire        done_counting,
    input  wire        ack,
    input  wire [9:0]  state,        // one-hot: bit0=S ... bit9=Wait
    output wire        B3_next,
    output wire        S_next,
    output wire        S1_next,
    output wire        Count_next,
    output wire        Wait_next,
    output wire        done,
    output wire        counting,
    output wire        shift_ena
);

// State bit indices for clarity
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

// Extract current states as bits
wire curr_S    = state[S_BIT];
wire curr_S1   = state[S1_BIT];
wire curr_S11  = state[S11_BIT];
wire curr_S110 = state[S110_BIT];
wire curr_B0   = state[B0_BIT];
wire curr_B1   = state[B1_BIT];
wire curr_B2   = state[B2_BIT];
wire curr_B3   = state[B3_BIT];
wire curr_COUNT= state[COUNT_BIT];
wire curr_WAIT = state[WAIT_BIT];

// Next state vector (one-hot) combinational calculation
reg [9:0] next_state;

always @(*) begin
    // Initialize next_state to zero
    next_state = 10'b0;

    // State transitions per the FSM diagram and input conditions
    if (curr_S) begin
        if (d == 1'b0) next_state[S_BIT] = 1'b1;      // S -> S if d=0
        else           next_state[S1_BIT] = 1'b1;     // S -> S1 if d=1
    end
    else if (curr_S1) begin
        if (d == 1'b0) next_state[S_BIT] = 1'b1;      // S1 -> S if d=0
        else           next_state[S11_BIT] = 1'b1;    // S1 -> S11 if d=1
    end
    else if (curr_S11) begin
        if (d == 1'b0) next_state[S110_BIT] = 1'b1;   // S11 -> S110 if d=0
        else           next_state[S11_BIT] = 1'b1;    // S11 -> S11 if d=1
    end
    else if (curr_S110) begin
        if (d == 1'b0) next_state[S_BIT] = 1'b1;      // S110 -> S if d=0
        else           next_state[B0_BIT] = 1'b1;     // S110 -> B0 if d=1
    end
    else if (curr_B0) begin
        next_state[B1_BIT] = 1'b1;                     // B0 -> B1 (always)
    end
    else if (curr_B1) begin
        next_state[B2_BIT] = 1'b1;                     // B1 -> B2 (always)
    end
    else if (curr_B2) begin
        next_state[B3_BIT] = 1'b1;                     // B2 -> B3 (always)
    end
    else if (curr_B3) begin
        next_state[COUNT_BIT] = 1'b1;                  // B3 -> Count (always)
    end
    else if (curr_COUNT) begin
        if (done_counting == 1'b0)
            next_state[COUNT_BIT] = 1'b1;              // Count -> Count if not done counting
        else
            next_state[WAIT_BIT] = 1'b1;               // Count -> Wait if done counting
    end
    else if (curr_WAIT) begin
        if (ack == 1'b0)
            next_state[WAIT_BIT] = 1'b1;               // Wait -> Wait if ack=0
        else
            next_state[S_BIT] = 1'b1;                   // Wait -> S if ack=1
    end
    else begin
        // Safety fallback to S if no valid state is active (should not happen)
        next_state[S_BIT] = 1'b1;
    end
end

// Map individual next state outputs from next_state vector
assign B3_next   = next_state[B3_BIT];
assign S_next    = next_state[S_BIT];
assign S1_next   = next_state[S1_BIT];
assign Count_next= next_state[COUNT_BIT];
assign Wait_next = next_state[WAIT_BIT];

// Outputs are purely functions of current state (Moore outputs)
assign done      = curr_WAIT;
assign counting  = curr_COUNT;
assign shift_ena = curr_B0 | curr_B1 | curr_B2 | curr_B3;

endmodule