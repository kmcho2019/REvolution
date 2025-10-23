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
            assign out[i*5 + j] = (i == j) || (a == b && i == 0 && j == 1) || (a == c && i == 0 && j == 2) || (a == d && i == 0 && j == 3) || (a == e && i == 0 && j == 4) || 
                                    (b == a && i == 1 && j == 0) || (b == c && i == 1 && j == 2) || (b == d && i == 1 && j == 3) || (b == e && i == 1 && j == 4) || 
                                    (c == a && i == 2 && j == 0) || (c == b && i == 2 && j == 1) || (c == d && i == 2 && j == 3) || (c == e && i == 2 && j == 4) || 
                                    (d == a && i == 3 && j == 0) || (d == b && i == 3 && j == 1) || (d == c && i == 3 && j == 2) || (d == e && i == 3 && j == 4) || 
                                    (e == a && i == 4 && j == 0) || (e == b && i == 4 && j == 1) || (e == c && i == 4 && j == 2) || (e == d && i == 4 && j == 3);
        end
    end
endgenerate

endmodule