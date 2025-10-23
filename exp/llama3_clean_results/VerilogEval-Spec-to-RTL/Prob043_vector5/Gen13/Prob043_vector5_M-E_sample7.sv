module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:0] i, j;
    reg [24:0] temp_out;

    always @(*) begin
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                case (i)
                    0: begin
                        case (j)
                            0: temp_out[24 - (i*5 + j)] = ~(a ^ a);
                            1: temp_out[24 - (i*5 + j)] = ~(a ^ b);
                            2: temp_out[24 - (i*5 + j)] = ~(a ^ c);
                            3: temp_out[24 - (i*5 + j)] = ~(a ^ d);
                            4: temp_out[24 - (i*5 + j)] = ~(a ^ e);
                        endcase
                    end
                    1: begin
                        case (j)
                            0: temp_out[24 - (i*5 + j)] = ~(b ^ a);
                            1: temp_out[24 - (i*5 + j)] = ~(b ^ b);
                            2: temp_out[24 - (i*5 + j)] = ~(b ^ c);
                            3: temp_out[24 - (i*5 + j)] = ~(b ^ d);
                            4: temp_out[24 - (i*5 + j)] = ~(b ^ e);
                        endcase
                    end
                    2: begin
                        case (j)
                            0: temp_out[24 - (i*5 + j)] = ~(c ^ a);
                            1: temp_out[24 - (i*5 + j)] = ~(c ^ b);
                            2: temp_out[24 - (i*5 + j)] = ~(c ^ c);
                            3: temp_out[24 - (i*5 + j)] = ~(c ^ d);
                            4: temp_out[24 - (i*5 + j)] = ~(c ^ e);
                        endcase
                    end
                    3: begin
                        case (j)
                            0: temp_out[24 - (i*5 + j)] = ~(d ^ a);
                            1: temp_out[24 - (i*5 + j)] = ~(d ^ b);
                            2: temp_out[24 - (i*5 + j)] = ~(d ^ c);
                            3: temp_out[24 - (i*5 + j)] = ~(d ^ d);
                            4: temp_out[24 - (i*5 + j)] = ~(d ^ e);
                        endcase
                    end
                    4: begin
                        case (j)
                            0: temp_out[24 - (i*5 + j)] = ~(e ^ a);
                            1: temp_out[24 - (i*5 + j)] = ~(e ^ b);
                            2: temp_out[24 - (i*5 + j)] = ~(e ^ c);
                            3: temp_out[24 - (i*5 + j)] = ~(e ^ d);
                            4: temp_out[24 - (i*5 + j)] = ~(e ^ e);
                        endcase
                    end
                endcase
            end
        end
        out = temp_out;
    end

endmodule