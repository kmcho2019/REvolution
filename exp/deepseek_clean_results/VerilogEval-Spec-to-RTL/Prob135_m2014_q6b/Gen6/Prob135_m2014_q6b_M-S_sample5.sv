module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];  // Direct output assignment

reg y1_next;

always @(*) begin
    y1_next = 0;  // Default to 0
    case ({y, w})
        // States where y1_next should be 1
        4'b0010,  // B->C
        4'b0011,  // B->D
        4'b0101,  // C->D
        4'b1001,  // E->D
        4'b1010,  // F->C
        4'b1011:   // F->D
            y1_next = 1;
    endcase
end

endmodule