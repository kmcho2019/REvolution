module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    reg [5:0] next_state;
    
    always @(*) begin
        case (1'b1)  // One-hot state decoding
            y[0]: next_state = w ? 6'b000001 : 6'b000010;  // A->A or A->B
            y[1]: next_state = w ? 6'b001000 : 6'b000100;  // B->D or B->C
            y[2]: next_state = w ? 6'b001000 : 6'b010000;  // C->D or C->E
            y[3]: next_state = w ? 6'b000001 : 6'b100000;  // D->A or D->F
            y[4]: next_state = w ? 6'b001000 : 6'b010000;  // E->D or E->E
            y[5]: next_state = w ? 6'b001000 : 6'b000100;  // F->D or F->C
            default: next_state = 6'b000001;  // Default to state A
        endcase
    end
    
    assign Y1 = next_state[1];  // Next state B
    assign Y3 = next_state[3];  // Next state D

endmodule