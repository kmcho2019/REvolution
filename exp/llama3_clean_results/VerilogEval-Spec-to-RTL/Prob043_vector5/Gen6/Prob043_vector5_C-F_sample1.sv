module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

generate
    for (genvar i = 0; i < 5; i++) begin
        for (genvar j = 0; j < 5; j++) begin
            assign out[i*5 + j] = (i == j) ? (a || b || c || d || e) : (i == 0 && j == 0) ? (a == a) : 
                                (i == 0 && j == 1) ? (a == b) : 
                                (i == 0 && j == 2) ? (a == c) : 
                                (i == 0 && j == 3) ? (a == d) : 
                                (i == 0 && j == 4) ? (a == e) : 
                                (i == 1 && j == 0) ? (b == a) : 
                                (i == 1 && j == 1) ? (b == b) : 
                                (i == 1 && j == 2) ? (b == c) : 
                                (i == 1 && j == 3) ? (b == d) : 
                                (i == 1 && j == 4) ? (b == e) : 
                                (i == 2 && j == 0) ? (c == a) : 
                                (i == 2 && j == 1) ? (c == b) : 
                                (i == 2 && j == 2) ? (c == c) : 
                                (i == 2 && j == 3) ? (c == d) : 
                                (i == 2 && j == 4) ? (c == e) : 
                                (i == 3 && j == 0) ? (d == a) : 
                                (i == 3 && j == 1) ? (d == b) : 
                                (i == 3 && j == 2) ? (d == c) : 
                                (i == 3 && j == 3) ? (d == d) : 
                                (i == 3 && j == 4) ? (d == e) : 
                                (i == 4 && j == 0) ? (e == a) : 
                                (i == 4 && j == 1) ? (e == b) : 
                                (i == 4 && j == 2) ? (e == c) : 
                                (i == 4 && j == 3) ? (e == d) : 
                                (i == 4 && j == 4) ? (e == e) : 1'b0;
        end
    end
endgenerate

endmodule