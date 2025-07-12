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
    temp_out = 0;
    for (i = 0; i < 5; i = i + 1) begin
        for (j = 0; j < 5; j = j + 1) begin
            case (i)
                0: begin
                    case (j)
                        0: temp_out[24] = ~(a ^ a);
                        1: temp_out[23] = ~(a ^ b);
                        2: temp_out[22] = ~(a ^ c);
                        3: temp_out[21] = ~(a ^ d);
                        4: temp_out[20] = ~(a ^ e);
                    endcase
                end
                1: begin
                    case (j)
                        0: temp_out[19] = ~(b ^ a);
                        1: temp_out[18] = ~(b ^ b);
                        2: temp_out[17] = ~(b ^ c);
                        3: temp_out[16] = ~(b ^ d);
                        4: temp_out[15] = ~(b ^ e);
                    endcase
                end
                2: begin
                    case (j)
                        0: temp_out[14] = ~(c ^ a);
                        1: temp_out[13] = ~(c ^ b);
                        2: temp_out[12] = ~(c ^ c);
                        3: temp_out[11] = ~(c ^ d);
                        4: temp_out[10] = ~(c ^ e);
                    endcase
                end
                3: begin
                    case (j)
                        0: temp_out[9] = ~(d ^ a);
                        1: temp_out[8] = ~(d ^ b);
                        2: temp_out[7] = ~(d ^ c);
                        3: temp_out[6] = ~(d ^ d);
                        4: temp_out[5] = ~(d ^ e);
                    endcase
                end
                4: begin
                    case (j)
                        0: temp_out[4] = ~(e ^ a);
                        1: temp_out[3] = ~(e ^ b);
                        2: temp_out[2] = ~(e ^ c);
                        3: temp_out[1] = ~(e ^ d);
                        4: temp_out[0] = ~(e ^ e);
                    endcase
                end
            endcase
        end
    end
    out = temp_out;
end

endmodule