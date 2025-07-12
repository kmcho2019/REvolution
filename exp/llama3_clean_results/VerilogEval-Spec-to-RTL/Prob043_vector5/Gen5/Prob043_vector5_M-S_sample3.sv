module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    integer i, j;
    reg [24:0] out_temp;

    always @(*) begin
        out_temp = 25'd0;
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                case (i)
                    0: begin
                        case (j)
                            0: out_temp[24 - (i*5 + j)] = ~(a ^ a);
                            1: out_temp[24 - (i*5 + j)] = ~(a ^ b);
                            2: out_temp[24 - (i*5 + j)] = ~(a ^ c);
                            3: out_temp[24 - (i*5 + j)] = ~(a ^ d);
                            4: out_temp[24 - (i*5 + j)] = ~(a ^ e);
                        endcase
                    end
                    1: begin
                        case (j)
                            0: out_temp[24 - (i*5 + j)] = ~(b ^ a);
                            1: out_temp[24 - (i*5 + j)] = ~(b ^ b);
                            2: out_temp[24 - (i*5 + j)] = ~(b ^ c);
                            3: out_temp[24 - (i*5 + j)] = ~(b ^ d);
                            4: out_temp[24 - (i*5 + j)] = ~(b ^ e);
                        endcase
                    end
                    2: begin
                        case (j)
                            0: out_temp[24 - (i*5 + j)] = ~(c ^ a);
                            1: out_temp[24 - (i*5 + j)] = ~(c ^ b);
                            2: out_temp[24 - (i*5 + j)] = ~(c ^ c);
                            3: out_temp[24 - (i*5 + j)] = ~(c ^ d);
                            4: out_temp[24 - (i*5 + j)] = ~(c ^ e);
                        endcase
                    end
                    3: begin
                        case (j)
                            0: out_temp[24 - (i*5 + j)] = ~(d ^ a);
                            1: out_temp[24 - (i*5 + j)] = ~(d ^ b);
                            2: out_temp[24 - (i*5 + j)] = ~(d ^ c);
                            3: out_temp[24 - (i*5 + j)] = ~(d ^ d);
                            4: out_temp[24 - (i*5 + j)] = ~(d ^ e);
                        endcase
                    end
                    4: begin
                        case (j)
                            0: out_temp[24 - (i*5 + j)] = ~(e ^ a);
                            1: out_temp[24 - (i*5 + j)] = ~(e ^ b);
                            2: out_temp[24 - (i*5 + j)] = ~(e ^ c);
                            3: out_temp[24 - (i*5 + j)] = ~(e ^ d);
                            4: out_temp[24 - (i*5 + j)] = ~(e ^ e);
                        endcase
                    end
                endcase
            end
        end
        out = out_temp;
    end
endmodule