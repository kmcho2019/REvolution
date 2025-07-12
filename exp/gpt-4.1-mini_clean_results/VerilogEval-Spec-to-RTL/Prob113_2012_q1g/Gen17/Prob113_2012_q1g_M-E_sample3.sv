module TopModule(
    input  [3:0] x,
    output       f
);

    reg f_reg;

    always @(*) begin
        case (x)
            4'b0000: f_reg = 1'b1; // x[3..0] = 0000, row 00 col 00
            4'b0010: f_reg = 1'b1; // row 00 col 10
            4'b1100: f_reg = 1'b1; // row 11 col 00
            4'b1101: f_reg = 1'b1; // row 11 col 01
            4'b1111: f_reg = 1'b1; // row 11 col 11
            4'b1000: f_reg = 1'b1; // row 10 col 00
            4'b1001: f_reg = 1'b1; // row 10 col 01
            4'b1010: f_reg = 1'b1; // row 10 col 10
            default: f_reg = 1'b0;
        endcase
    end

    assign f = f_reg;

endmodule