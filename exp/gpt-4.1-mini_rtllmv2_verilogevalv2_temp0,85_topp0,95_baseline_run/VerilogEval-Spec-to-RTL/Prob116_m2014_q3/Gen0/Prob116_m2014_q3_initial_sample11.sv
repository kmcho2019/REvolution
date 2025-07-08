module TopModule(
    input  [3:0] x,
    output      f
);

    reg f_reg;

    always @(*) begin
        case (x)
            4'b0111: f_reg = 1;
            4'b1100: f_reg = 1;
            4'b1101: f_reg = 1;
            4'b1110: f_reg = 1;
            4'b1111: f_reg = 1;
            4'b1000: f_reg = 1;
            4'b1001: f_reg = 1;
            default: f_reg = 0;
        endcase
    end

    assign f = f_reg;

endmodule