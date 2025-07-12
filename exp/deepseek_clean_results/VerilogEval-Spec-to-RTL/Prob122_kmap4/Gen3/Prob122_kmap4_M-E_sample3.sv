module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire [1:0] sum_ab = a + b;
    wire [1:0] sum_cd = c + d;
    
    assign out = (sum_ab == sum_cd);

endmodule