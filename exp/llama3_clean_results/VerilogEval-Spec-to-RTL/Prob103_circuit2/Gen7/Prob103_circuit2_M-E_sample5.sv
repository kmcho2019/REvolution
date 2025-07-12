module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire [1:0] count;
    
    assign count = a + b + c + d;
    assign q = ~(count[0] ^ count[1]);
endmodule