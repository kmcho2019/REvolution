module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [24:0] out_reg;

always @(*) begin
    reg [4:0] i, j;
    out_reg = 0;
    for (i = 0; i < 5; i = i + 1) begin
        for (j = 0; j < 5; j = j + 1) begin
            case (i)
                0: begin
                    case (j)
                        0: out_reg[24] = ~(a ^ a);
                        1: out_reg[23] = ~(a ^ b);
                        2: out_reg[22] = ~(a ^ c);
                        3: out_reg[21] = ~(a ^ d);
                        4: out_reg[20] = ~(a ^ e);
                    endcase
                end
                1: begin
                    case (j)
                        0: out_reg[19] = ~(b ^ a);
                        1: out_reg[18] = ~(b ^ b);
                        2: out_reg[17] = ~(b ^ c);
                        3: out_reg[16] = ~(b ^ d);
                        4: out_reg[15] = ~(b ^ e);
                    endcase
                end
                2: begin
                    case (j)
                        0: out_reg[14] = ~(c ^ a);
                        1: out_reg[13] = ~(c ^ b);
                        2: out_reg[12] = ~(c ^ c);
                        3: out_reg[11] = ~(c ^ d);
                        4: out_reg[10] = ~(c ^ e);
                    endcase
                end
                3: begin
                    case (j)
                        0: out_reg[9] = ~(d ^ a);
                        1: out_reg[8] = ~(d ^ b);
                        2: out_reg[7] = ~(d ^ c);
                        3: out_reg[6] = ~(d ^ d);
                        4: out_reg[5] = ~(d ^ e);
                    endcase
                end
                4: begin
                    case (j)
                        0: out_reg[4] = ~(e ^ a);
                        1: out_reg[3] = ~(e ^ b);
                        2: out_reg[2] = ~(e ^ c);
                        3: out_reg[1] = ~(e ^ d);
                        4: out_reg[0] = ~(e ^ e);
                    endcase
                end
            endcase
        end
    end
end

assign out = out_reg;

endmodule