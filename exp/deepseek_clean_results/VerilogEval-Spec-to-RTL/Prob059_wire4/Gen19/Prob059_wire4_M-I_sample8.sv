module TopModule(input a, b, c, output w, x, y, z);
    assign w = a;
    assign z = c;
    assign {x, y} = {b, b};
endmodule