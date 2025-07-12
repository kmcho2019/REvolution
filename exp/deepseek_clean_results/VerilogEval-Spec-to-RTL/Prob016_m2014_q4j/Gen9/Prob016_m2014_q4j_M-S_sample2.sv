module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire c0, c1, c2;
    
    // Bit 0 (LSB)
    assign {c0, sum[0]} = x[0] + y[0];
    
    // Bit 1
    assign {c1, sum[1]} = x[1] + y[1] + c0;
    
    // Bit 2
    assign {c2, sum[2]} = x[2] + y[2] + c1;
    
    // Bit 3 (MSB) and overflow
    assign {sum[4], sum[3]} = x[3] + y[3] + c2;
endmodule