module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    reg Y1_reg;
    always @(*) begin
        case (y)
            3'b000: Y1_reg = w; // A
            3'b001: Y1_reg = w; // B
            3'b010: Y1_reg = 1'b1; // C
            3'b011: Y1_reg = 1'b1; // D
            3'b100: Y1_reg = 1'b1; // E
            3'b101: Y1_reg = 1'b1; // F
            default: Y1_reg = 1'b0; // default
        endcase
    end

    assign Y1 = Y1_reg;

endmodule