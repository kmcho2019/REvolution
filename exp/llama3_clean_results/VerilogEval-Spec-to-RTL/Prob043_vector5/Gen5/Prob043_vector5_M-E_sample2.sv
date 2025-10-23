module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    reg [4:0] idx1, idx2;
    reg [24:0] temp_out;

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                case (i)
                    0: idx1 = a;
                    1: idx1 = b;
                    2: idx1 = c;
                    3: idx1 = d;
                    4: idx1 = e;
                endcase
                case (j)
                    0: idx2 = a;
                    1: idx2 = b;
                    2: idx2 = c;
                    3: idx2 = d;
                    4: idx2 = e;
                endcase
                temp_out[(i * 5) + j] = ~(idx1 ^ idx2);
            end
        end
        out = temp_out;
    end
endmodule