module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Next state logic using more explicit case structure
    always_comb begin
        casez (state)
            10'b0000000001: begin // S
                S_next = ~d;
                S1_next = d;
                {B3_next, Count_next, Wait_next} = 3'b0;
            end
            10'b0000000010: begin // S1
                S_next = ~d;
                S1_next = d;
                {B3_next, Count_next, Wait_next} = 3'b0;
            end
            10'b0000000100: begin // S11
                S_next = 1'b0;
                S1_next = d;
                {B3_next, Count_next, Wait_next} = 3'b0;
            end
            10'b0000001000: begin // S110
                S_next = ~d;
                {S1_next, B3_next, Count_next, Wait_next} = 4'b0;
            end
            10'b0000010000: begin // B0
                {S_next, S1_next, B3_next, Count_next, Wait_next} = 5'b0;
            end
            10'b0000100000: begin // B1
                {S_next, S1_next, B3_next, Count_next, Wait_next} = 5'b0;
            end
            10'b0001000000: begin // B2
                B3_next = 1'b1;
                {S_next, S1_next, Count_next, Wait_next} = 4'b0;
            end
            10'b0010000000: begin // B3
                Count_next = 1'b1;
                {S_next, S1_next, B3_next, Wait_next} = 4'b0;
            end
            10'b0100000000: begin // Count
                Count_next = ~done_counting;
                Wait_next = done_counting;
                {S_next, S1_next, B3_next} = 3'b0;
            end
            10'b1000000000: begin // Wait
                S_next = ack;
                Wait_next = ~ack;
                {S1_next, B3_next, Count_next} = 3'b0;
            end
            default: begin
                {S_next, S1_next, B3_next, Count_next, Wait_next} = 5'b0;
            end
        endcase
    end

    // Output logic remains as continuous assignments
    assign shift_ena = |state[7:4];  // Active in B0-B3 states
    assign counting = state[8];      // Active in Count state
    assign done = state[9];          // Active in Wait state

endmodule