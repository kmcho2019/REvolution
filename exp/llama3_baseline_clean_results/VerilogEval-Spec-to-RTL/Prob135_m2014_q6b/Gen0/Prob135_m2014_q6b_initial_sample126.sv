module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next state logic for y[1]
always @(*) begin
    case ({y, w})
        // Transitions that set y[1]
        3'b0000: Y1 = 0; // A to B
        3'b0001: Y1 = 0; // A to A
        3'b0010: Y1 = 0; // B to C
        3'b0011: Y1 = 1; // B to D
        3'b0100: Y1 = 1; // C to E
        3'b0101: Y1 = 1; // C to D
        3'b0110: Y1 = 1; // D to F
        3'b0111: Y1 = 0; // D to A
        3'b1000: Y1 = 1; // E to E
        3'b1001: Y1 = 1; // E to D
        3'b1010: Y1 = 0; // F to C
        3'b1011: Y1 = 1; // F to D
        default: Y1 = 0;
    endcase
end

endmodule