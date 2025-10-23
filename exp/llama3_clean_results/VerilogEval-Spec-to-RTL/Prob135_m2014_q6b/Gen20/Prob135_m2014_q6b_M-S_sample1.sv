module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    reg Y1_reg;

    always @(*) begin
        case (y)
            3'b000: Y1_reg = w? 0 : 0; // A to A or B
            3'b001: Y1_reg = w? 0 : 1; // B to D or C
            3'b010: Y1_reg = w? 0 : 1; // C to D or E
            3'b011: Y1_reg = w? 0 : 1; // D to A or F
            3'b100: Y1_reg = w? 0 : 1; // E to D or E
            3'b101: Y1_reg = w? 0 : 0; // F to D or C
            default: Y1_reg = 0;
        endcase
    end

    assign Y1 = Y1_reg;

endmodule