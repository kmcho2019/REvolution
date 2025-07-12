module TopModule(input x, input y, output z);
    wire a = (x ^ y) & x;
    wire b = ~(x ^ y);
    assign z = a ^ b;
endmodule