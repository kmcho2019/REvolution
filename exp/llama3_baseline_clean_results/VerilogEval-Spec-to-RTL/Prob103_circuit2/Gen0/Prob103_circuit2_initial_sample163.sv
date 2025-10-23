module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;
    
    assign q = (~a & ~b) | (~b & ~c & d) | (~b & d) | (a & ~c & d) | (a & ~b & c);
endmodule