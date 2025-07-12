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

    // Priority-encoded state representation
    wire [3:0] curr_state_enc;
    assign curr_state_enc = 
        state[9] ? 4'd9 :  // Wait
        state[8] ? 4'd8 :  // Count
        state[7] ? 4'd7 :  // B3
        state[6] ? 4'd6 :  // B2
        state[5] ? 4'd5 :  // B1
        state[4] ? 4'd4 :  // B0
        state[3] ? 4'd3 :  // S110
        state[2] ? 4'd2 :  // S11
        state[1] ? 4'd1 :  // S1
        4'd0;              // S

    // Next state logic using priority-based case approach
    reg [3:0] next_state_enc;
    always @(*) begin
        case (curr_state_enc)
            4'd0: next_state_enc = d ? 4'd1 : 4'd0;  // S -> S1 or S
            4'd1: next_state_enc = d ? 4'd2 : 4'd0;  // S1 -> S11 or S
            4'd2: next_state_enc = d ? 4'd2 : 4'd3;  // S11 -> S11 or S110
            4'd3: next_state_enc = d ? 4'd4 : 4'd0;  // S110 -> B0 or S
            4'd4: next_state_enc = 4'd5;             // B0 -> B1
            4'd5: next_state_enc = 4'd6;             // B1 -> B2
            4'd6: next_state_enc = 4'd7;             // B2 -> B3
            4'd7: next_state_enc = 4'd8;             // B3 -> Count
            4'd8: next_state_enc = done_counting ? 4'd9 : 4'd8; // Count -> Wait or Count
            4'd9: next_state_enc = ack ? 4'd0 : 4'd9; // Wait -> S or Wait
            default: next_state_enc = 4'd0;
        endcase
    end

    // Convert encoded next state back to one-hot
    assign S_next = (next_state_enc == 4'd0);
    assign S1_next = (next_state_enc == 4'd1);
    assign B3_next = (next_state_enc == 4'd7);
    assign Count_next = (next_state_enc == 4'd8);
    assign Wait_next = (next_state_enc == 4'd9);

    // Output logic with pipelining potential
    reg shift_ena_reg, counting_reg, done_reg;
    always @(*) begin
        case (curr_state_enc)
            4'd4, 4'd5, 4'd6, 4'd7: shift_ena_reg = 1'b1;
            default: shift_ena_reg = 1'b0;
        endcase
        
        counting_reg = (curr_state_enc == 4'd8);
        done_reg = (curr_state_enc == 4'd9);
    end

    assign shift_ena = shift_ena_reg;
    assign counting = counting_reg;
    assign done = done_reg;

endmodule