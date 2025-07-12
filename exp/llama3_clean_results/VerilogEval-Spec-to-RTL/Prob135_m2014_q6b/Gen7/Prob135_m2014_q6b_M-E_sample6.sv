module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case ({y, w})
        // A (0) --0--> B
        3'b0000: Y1 = 1'b0;
        // A (0) --1--> A
        3'b0001: Y1 = 1'b0;
        // B (0) --0--> C
        3'b0010: Y1 = 1'b1;
        // B (0) --1--> D
        3'b0011: Y1 = 1'b1;
        // C (0) --0--> E
        3'b0100: Y1 = 1'b1;
        // C (0) --1--> D
        3'b0101: Y1 = 1'b1;
        // D (0) --0--> F
        3'b0110: Y1 = 1'b0;
        // D (0) --1--> A
        3'b0111: Y1 = 1'b0;
        // E (1) --0--> E
        3'b1000: Y1 = 1'b1;
        // E (1) --1--> D
        3'b1001: Y1 = 1'b1;
        // F (1) --0--> C
        3'b1010: Y1 = 1'b0;
        // F (1) --1--> D
        3'b1011: Y1 = 1'b1;
        default: Y1 = 1'b0;
    endcase
end

endmodule