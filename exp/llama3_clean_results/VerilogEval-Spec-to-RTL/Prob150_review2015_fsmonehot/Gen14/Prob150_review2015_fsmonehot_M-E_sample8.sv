module TopModule (
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,  // one-hot encoding
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Define the states as enumerated values
    typedef enum logic [3:0] {
        S,
        S1,
        S11,
        S110,
        B0,
        B1,
        B2,
        B3,
        Count,
        Wait
    } state_type;

    // Current state
    state_type current_state;
    always_comb begin
        case (state)
            10'b0000000001: current_state = S;
            10'b0000000010: current_state = S1;
            10'b0000000100: current_state = S11;
            10'b0000001000: current_state = S110;
            10'b0000010000: current_state = B0;
            10'b0000100000: current_state = B1;
            10'b0001000000: current_state = B2;
            10'b0010000000: current_state = B3;
            10'b0100000000: current_state = Count;
            10'b1000000000: current_state = Wait;
            default: current_state = S;
        endcase
    end

    // Next-state logic equations using case statement
    always_comb begin
        case (current_state)
            S: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 1;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 1;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            S1: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 1;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            S11: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 0;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            S110: begin
                if (~d) B3_next = 0;
                else B3_next = 1;
                if (~d) S_next = 1;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            B0: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 0;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            B1: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 0;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            B2: begin
                if (~d) B3_next = 1;
                else B3_next = 1;
                if (~d) S_next = 0;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            B3: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 0;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 1;
                else Count_next = 1;
                if (~d) Wait_next = 0;
                else Wait_next = 0;
            end
            Count: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 0;
                else S_next = 0;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 1;
                else Count_next = 0;
                if (~d) Wait_next = 0;
                else Wait_next = 1;
            end
            Wait: begin
                if (~d) B3_next = 0;
                else B3_next = 0;
                if (~d) S_next = 0;
                else S_next = 1;
                if (~d) S1_next = 0;
                else S1_next = 0;
                if (~d) Count_next = 0;
                else Count_next = 0;
                if (~d) Wait_next = 1;
                else Wait_next = 0;
            end
            default: begin
                B3_next = 0;
                S_next = 0;
                S1_next = 0;
                Count_next = 0;
                Wait_next = 0;
            end
        endcase
    end

    // Output logic equations
    assign done = (current_state == Wait);
    assign counting = (current_state == Count);
    assign shift_ena = (current_state == B0) || (current_state == B1) || (current_state == B2) || (current_state == B3);

endmodule