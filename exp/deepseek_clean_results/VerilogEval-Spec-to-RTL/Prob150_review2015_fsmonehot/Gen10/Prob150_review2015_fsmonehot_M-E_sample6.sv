module TopModule (
    input d,
    input done_counting,
    input ack,
    input [9:0] state,  // Maintain interface compatibility
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

    // Novel hierarchical state encoding
    wire [2:0] S_group = state[3:0] == 4'b0001 ? 3'b001 :  // S
                         state[3:0] == 4'b0010 ? 3'b010 :  // S1
                         state[3:0] == 4'b0100 ? 3'b011 :  // S11
                         state[3:0] == 4'b1000 ? 3'b100 :  // S110
                         3'b000;
    
    wire [1:0] B_stage = state[7:4];  // Encodes B0-B3 progression
    
    wire Count_curr = state[8];
    wire Wait_curr = state[9];

    // Early transition condition evaluation
    wire S_family_transition = |state[3:0];
    wire B_family_transition = |state[7:4];
    wire return_to_S_cond = (S_group[0] | S_group[1] | S_group[3]) & ~d;
    wire advance_B = B_family_transition;

    // Next state logic using hierarchical encoding
    assign S_next = return_to_S_cond | (Wait_curr & ack);
    assign S1_next = S_group[0] & d;
    
    // B-stage progression with reduced logic
    wire B3_next_internal = B_stage == 2'b10;  // B2->B3
    assign B3_next = B3_next_internal;
    
    // Count/Wait logic with early evaluation
    wire count_hold = Count_curr & ~done_counting;
    assign Count_next = B3_next_internal | count_hold;
    assign Wait_next = (Count_curr & done_counting) | (Wait_curr & ~ack);

    // Pipelined output logic
    reg shift_ena_reg;
    always @(*) begin
        case (B_stage)
            2'b00: shift_ena_reg = 1'b0;  // Not in B phase
            2'b01: shift_ena_reg = 1'b1;  // B0
            2'b10: shift_ena_reg = 1'b1;  // B1-B2
            default: shift_ena_reg = 1'b0;
        endcase
    end
    
    // Output assignments
    assign shift_ena = shift_ena_reg | (B_stage == 2'b11);  // B3
    assign counting = Count_curr;
    assign done = Wait_curr;

endmodule