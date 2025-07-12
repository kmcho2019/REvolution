module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Hybrid encoding: 
                        // [3:0] - priority encoded sequence (S=0001, S1=0010, S11=0100, S110=1000)
                        // [9:4] - one-hot operational states (B0=bit4, B1=bit5, B2=bit6, B3=bit7, Count=bit8, Wait=bit9)
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

// State grouping
wire in_sequence = |state[3:0];
wire in_shift = |state[7:4];
wire in_count = state[8];
wire in_wait = state[9];

// Next state logic - sequence detection (priority encoded)
always @(*) begin
    // Defaults
    S_next = 0;
    S1_next = 0;
    B3_next = 0;
    Count_next = 0;
    Wait_next = 0;
    
    // Sequence states
    if (state[0]) begin // S state
        S_next = ~d;
        S1_next = d;
    end
    else if (state[1]) begin // S1 state
        S_next = ~d;
        if (d) S1_next = 1; // Will be recoded as S11
    end
    else if (state[2]) begin // S11 state
        if (~d) S1_next = 1; // Will be recoded as S110
    end
    else if (state[3]) begin // S110 state
        S_next = ~d;
        if (d) B3_next = 1; // Transition to B0 will be handled by shift logic
    end
    
    // Operational states
    if (state[4]) B3_next = 1; // B0->B1 (encoded as B3_next)
    if (state[5]) B3_next = 1; // B1->B2
    if (state[6]) B3_next = 1; // B2->B3
    if (state[7]) Count_next = 1; // B3->Count
    if (in_count) begin
        Count_next = ~done_counting;
        Wait_next = done_counting;
    end
    if (in_wait) begin
        Wait_next = ~ack;
        S_next = ack;
    end
end

// Output logic with pipelining
always @(*) begin
    // Default outputs
    done = 0;
    counting = 0;
    shift_ena = 0;
    
    // Operational state outputs
    if (in_shift) shift_ena = 1;
    if (in_count) counting = 1;
    if (in_wait) done = 1;
end

// State recoding for S11/S110 (handled via S1_next)
// This is handled by the priority encoding in the state register

endmodule