module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire carry0, carry1, carry2;
    
    assign {carry0, sum[0]} = x[0] + y[0];
    assign {carry1, sum[1]} = x[1] + y[1] + carry0;
    assign {carry2, sum[2]} = x[2] + y[2] + carry1;
    assign {sum[4], sum[3]} = x[3] + y[3] + carry2;
endmodule