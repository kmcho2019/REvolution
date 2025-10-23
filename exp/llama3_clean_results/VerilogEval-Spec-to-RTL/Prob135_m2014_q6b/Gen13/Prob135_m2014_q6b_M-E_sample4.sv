module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = w; // A
            3'b001: Y1 = w ? 1'b1 : 0; // B
            3'b010: Y1 = w ? 1'b1 : 0; // C
            3'b011: Y1 = 1'b1; // D
            3'b100: Y1 = 1'b1; // E
            3'b101: Y1 = w ? 1'b1 : 0; // F
            default: Y1 = 1'bx; // undefined
        endcase
    end

endmodule