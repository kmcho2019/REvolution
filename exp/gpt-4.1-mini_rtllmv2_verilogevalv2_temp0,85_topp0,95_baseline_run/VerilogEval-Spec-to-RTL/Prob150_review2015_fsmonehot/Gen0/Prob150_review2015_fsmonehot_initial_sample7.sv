module TopModule(
    input        d,
    input        done_counting,
    input        ack,
    input [9:0]  state,
    output       B3_next,
    output       S_next,
    output       S1_next,
    output       Count_next,
    output       Wait_next,
    output       done,
    output       counting,
    output       shift_ena
);

    // State encoding (one-hot)
    // bit positions: [0]=S, [1]=S1, [2]=S11, [3]=S110, [4]=B0, [5]=B1, [6]=B2, [7]=B3, [8]=Count, [9]=Wait
    localparam S    = 10'b0000000001;
    localparam S1   = 10'b0000000010;
    localparam S11  = 10'b0000000100;
    localparam S110 = 10'b0000001000;
    localparam B0   = 10'b0000010000;
    localparam B1   = 10'b0000100000;
    localparam B2   = 10'b0001000000;
    localparam B3   = 10'b0010000000;
    localparam Count= 10'b0100000000;
    localparam Wait = 10'b1000000000;

    reg [9:0] next_state;

    always @(*) begin
        // Default next state zero
        next_state = 10'b0;

        // State S transitions
        if (state[0]) begin // S
            if (d == 0)
                next_state = S;   // stay S
            else
                next_state = S1;
        end

        // State S1 transitions
        else if (state[1]) begin // S1
            if (d == 0)
                next_state = S;
            else
                next_state = S11;
        end

        // State S11 transitions
        else if (state[2]) begin // S11
            if (d == 0)
                next_state = S110;
            else
                next_state = S11;  // stay S11
        end

        // State S110 transitions
        else if (state[3]) begin // S110
            if (d == 0)
                next_state = S;
            else
                next_state = B0;
        end

        // State B0 transitions (unconditional)
        else if (state[4]) begin
            next_state = B1;
        end

        // State B1 transitions (unconditional)
        else if (state[5]) begin
            next_state = B2;
        end

        // State B2 transitions (unconditional)
        else if (state[6]) begin
            next_state = B3;
        end

        // State B3 transitions (unconditional)
        else if (state[7]) begin
            next_state = Count;
        end

        // State Count transitions
        else if (state[8]) begin // Count
            if (done_counting == 0)
                next_state = Count;
            else
                next_state = Wait;
        end

        // State Wait transitions
        else if (state[9]) begin // Wait
            if (ack == 0)
                next_state = Wait;
            else
                next_state = S;
        end

        else begin
            // Default to state S if no valid state bit set
            next_state = S;
        end
    end

    // Output logic
    // Outputs depend on current state (Moore machine)

    // done = 1 in Wait state
    assign done = state[9];

    // counting = 1 in Count state
    assign counting = state[8];

    // shift_ena = 1 in B0, B1, B2, B3 states
    assign shift_ena = state[4] | state[5] | state[6] | state[7];

    // Output signals indicating next-state equal to specific states
    assign B3_next   = (next_state == B3);
    assign S_next    = (next_state == S);
    assign S1_next   = (next_state == S1);
    assign Count_next= (next_state == Count);
    assign Wait_next = (next_state == Wait);

endmodule