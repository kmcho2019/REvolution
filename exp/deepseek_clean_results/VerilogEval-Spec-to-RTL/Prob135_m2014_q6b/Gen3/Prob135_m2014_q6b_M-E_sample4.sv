module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

reg y1_next;

always @(*) begin
    case ({y, w})
        // State A (000)
        4'b0000: y1_next = 0;  // A->B
        4'b0001: y1_next = 0;  // A->A
        
        // State B (001)
        4'b0010: y1_next = 1;  // B->C
        4'b0011: y1_next = 1;  // B->D
        
        // State C (010)
        4'b0100: y1_next = 0;  // C->E
        4'b0101: y1_next = 1;  // C->D
        
        // State D (011)
        4'b0110: y1_next = 1;  // D->F
        4'b0111: y1_next = 0;  // D->A
        
        // State E (100)
        4'b1000: y1_next = 0;  // E->E
        4'b1001: y1_next = 1;  // E->D
        
        // State F (101)
        4'b1010: y1_next = 1;  // F->C
        4'b1011: y1_next = 1;  // F->D
        
        default: y1_next = 0;   // Should never occur
    endcase
end

endmodule