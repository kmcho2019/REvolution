module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire [1:0] count_ab;
    wire [1:0] count_cd;
    wire [1:0] total_count;
    
    assign count_ab = {a, b};
    assign count_cd = {c, d};
    
    assign total_count = count_ab + count_cd;
    
    assign q = (total_count >= 2) || ((~a) && (~b) && (count_cd != 2'b00));

endmodule