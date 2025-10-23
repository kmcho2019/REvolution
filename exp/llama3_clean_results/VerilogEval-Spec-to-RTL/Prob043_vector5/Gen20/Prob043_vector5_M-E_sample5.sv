module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [24:0] out_reg;
    integer i, j;

    always @(*) begin
        out_reg = 0;
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                case ({i, j})
                    2'b00: out_reg[24] = (a == a);
                    2'b01: out_reg[23] = (a == b);
                    2'b02: out_reg[22] = (a == c);
                    2'b03: out_reg[21] = (a == d);
                    2'b04: out_reg[20] = (a == e);
                    2'b10: out_reg[19] = (b == a);
                    2'b11: out_reg[18] = (b == b);
                    2'b12: out_reg[17] = (b == c);
                    2'b13: out_reg[16] = (b == d);
                    2'b14: out_reg[15] = (b == e);
                    2'b20: out_reg[14] = (c == a);
                    2'b21: out_reg[13] = (c == b);
                    2'b22: out_reg[12] = (c == c);
                    2'b23: out_reg[11] = (c == d);
                    2'b24: out_reg[10] = (c == e);
                    2'b30: out_reg[9] = (d == a);
                    2'b31: out_reg[8] = (d == b);
                    2'b32: out_reg[7] = (d == c);
                    2'b33: out_reg[6] = (d == d);
                    2'b34: out_reg[5] = (d == e);
                    2'b40: out_reg[4] = (e == a);
                    2'b41: out_reg[3] = (e == b);
                    2'b42: out_reg[2] = (e == c);
                    2'b43: out_reg[1] = (e == d);
                    2'b44: out_reg[0] = (e == e);
                    default: ;
                endcase
            end
        end
        out = out_reg;
    end

endmodule