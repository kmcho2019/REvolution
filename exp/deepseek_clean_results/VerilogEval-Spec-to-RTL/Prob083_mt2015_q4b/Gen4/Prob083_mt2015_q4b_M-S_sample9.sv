module TopModule(input x, y, output z);
    assign z = ~(x ^ y);
endmodule