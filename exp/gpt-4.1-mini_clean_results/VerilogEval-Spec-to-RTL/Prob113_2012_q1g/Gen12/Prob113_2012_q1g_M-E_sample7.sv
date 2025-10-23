module TopModule(
    input  [3:0] x,
    output       f
);

    reg f_reg;

    always @(*) begin
        case (x)
            4'b0000: f_reg = 1'b1; // x3x2x1x0 = 0000, Karnaugh cell (00,00)
            4'b0001: f_reg = 1'b0; // (00,01)
            4'b0011: f_reg = 1'b0; // (00,11)
            4'b0010: f_reg = 1'b1; // (00,10)
            4'b0100: f_reg = 1'b0; // (01,00)
            4'b0101: f_reg = 1'b0; // (01,01)
            4'b0111: f_reg = 1'b0; // (01,11)
            4'b0110: f_reg = 1'b0; // (01,10)
            4'b1100: f_reg = 1'b1; // (11,00)
            4'b1101: f_reg = 1'b1; // (11,01)
            4'b1111: f_reg = 1'b1; // (11,11)
            4'b1110: f_reg = 1'b0; // (11,10)
            4'b1000: f_reg = 1'b1; // (10,00)
            4'b1001: f_reg = 1'b1; // (10,01)
            4'b1011: f_reg = 1'b0; // (10,11)
            4'b1010: f_reg = 1'b1; // (10,10)
            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule