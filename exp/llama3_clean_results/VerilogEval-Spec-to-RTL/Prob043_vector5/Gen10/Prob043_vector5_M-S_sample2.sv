module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            assign out[i*5 + j] = (i == 0) ? (j == 0) ? (a == a) :
                                (j == 1) ? (a == b) :
                                (j == 2) ? (a == c) :
                                (j == 3) ? (a == d) :
                                (j == 4) ? (a == e) :
                              (i == 1) ? (j == 0) ? (b == a) :
                                (j == 1) ? (b == b) :
                                (j == 2) ? (b == c) :
                                (j == 3) ? (b == d) :
                                (j == 4) ? (b == e) :
                              (i == 2) ? (j == 0) ? (c == a) :
                                (j == 1) ? (c == b) :
                                (j == 2) ? (c == c) :
                                (j == 3) ? (c == d) :
                                (j == 4) ? (c == e) :
                              (i == 3) ? (j == 0) ? (d == a) :
                                (j == 1) ? (d == b) :
                                (j == 2) ? (d == c) :
                                (j == 3) ? (d == d) :
                                (j == 4) ? (d == e) :
                              (i == 4) ? (j == 0) ? (e == a) :
                                (j == 1) ? (e == b) :
                                (j == 2) ? (e == c) :
                                (j == 3) ? (e == d) :
                                (j == 4) ? (e == e) : 1'bx;
        end
    end
endgenerate

endmodule