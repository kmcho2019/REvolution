module TopModule(x, y, z);
    input x, y;
    output z;
    assign z = (x == 1 && y == 1) || (x == 1 && y == 0);
endmodule