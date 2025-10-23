module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using case statement
    reg next_y1;
    always @(*) begin
        case ({y, w})
            // State A transitions
            4'b000_0: next_y1 = 1'b0;  // A->B
            4'b000_1: next_y1 = 1'b0;  // A->A
            
            // State B transitions
            4'b001_0: next_y1 = 1'b0;  // B->C
            4'b001_1: next_y1 = 1'b1;  // B->D
            
            // State C transitions
            4'b010_0: next_y1 = 1'b0;  // C->E
            4'b010_1: next_y1 = 1'b1;  // C->D
            
            // State D transitions
            4'b011_0: next_y1 = 1'b1;  // D->F
            4'b011_1: next_y1 = 1'b0;  // D->A
            
            // State E transitions
            4'b100_0: next_y1 = 1'b0;  // E->E (maintain y[1]=0)
            4'b100_1: next_y1 = 1'b1;  // E->D
            
            // State F transitions
            4'b101_0: next_y1 = 1'b0;  // F->C
            4'b101_1: next_y1 = 1'b1;  // F->D
            
            default: next_y1 = 1'b0;   // Should never occur
        endcase
    end

endmodule