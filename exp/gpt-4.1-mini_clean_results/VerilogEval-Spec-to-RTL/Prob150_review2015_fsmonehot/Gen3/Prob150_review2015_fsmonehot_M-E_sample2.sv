module TopModule (
    input  wire       d,
    input  wire       done_counting,
    input  wire       ack,
    input  wire [9:0] state,       // One-hot encoded current state vector
    output wire       B3_next,
    output wire       S_next,
    output wire       S1_next,
    output wire       Count_next,
    output wire       Wait_next,
    output wire       done,
    output wire       counting,
    output wire       shift_ena
);

// One-hot state bit indices for clarity
localparam S_bit     = 0;
localparam S1_bit    = 1;
localparam S11_bit   = 2;
localparam S110_bit  = 3;
localparam B0_bit    = 4;
localparam B1_bit    = 5;
localparam B2_bit    = 6;
localparam B3_bit    = 7;
localparam Count_bit = 8;
localparam Wait_bit  = 9;

// Create a 10-bit vector for next state, all zero initially
reg [9:0] next_state_vec;

always @(*) begin
    next_state_vec = 10'b0;

    // From state S (bit 0)
    if (state[S_bit]) begin
        if (d == 1'b0)
            next_state_vec[S_bit] = 1'b1;
        else
            next_state_vec[S1_bit] = 1'b1;
    end

    // From state S1 (bit 1)
    else if (state[S1_bit]) begin
        if (d == 1'b0)
            next_state_vec[S_bit] = 1'b1;
        else
            next_state_vec[S11_bit] = 1'b1;
    end

    // From state S11 (bit 2)
    else if (state[S11_bit]) begin
        if (d == 1'b0)
            next_state_vec[S110_bit] = 1'b1;
        else
            next_state_vec[S11_bit] = 1'b1;
    end

    // From state S110 (bit 3)
    else if (state[S110_bit]) begin
        if (d == 1'b0)
            next_state_vec[S_bit] = 1'b1;
        else
            next_state_vec[B0_bit] = 1'b1;
    end

    // From state B0 (bit 4), always to B1
    else if (state[B0_bit]) begin
        next_state_vec[B1_bit] = 1'b1;
    end

    // From state B1 (bit 5), always to B2
    else if (state[B1_bit]) begin
        next_state_vec[B2_bit] = 1'b1;
    end

    // From state B2 (bit 6), always to B3
    else if (state[B2_bit]) begin
        next_state_vec[B3_bit] = 1'b1;
    end

    // From state B3 (bit 7), always to Count
    else if (state[B3_bit]) begin
        next_state_vec[Count_bit] = 1'b1;
    end

    // From state Count (bit 8)
    else if (state[Count_bit]) begin
        if (done_counting == 1'b0)
            next_state_vec[Count_bit] = 1'b1;
        else
            next_state_vec[Wait_bit] = 1'b1;
    end

    // From state Wait (bit 9)
    else if (state[Wait_bit]) begin
        if (ack == 1'b0)
            next_state_vec[Wait_bit] = 1'b1;
        else
            next_state_vec[S_bit] = 1'b1;
    end
end

// Outputs assigned from current state
assign done     = state[Wait_bit];
assign counting = state[Count_bit];
assign shift_ena= |(state[7:4]); // B0, B1, B2, B3 active high

// Outputs to indicate next state bits asserted
assign B3_next    = next_state_vec[B3_bit];
assign S_next     = next_state_vec[S_bit];
assign S1_next    = next_state_vec[S1_bit];
assign Count_next = next_state_vec[Count_bit];
assign Wait_next  = next_state_vec[Wait_bit];

endmodule