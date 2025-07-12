module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    assign a = x & (!y);
    assign b = (x & y) | (!x & !y);
    assign z = (a | b) ^ (a & b);
endmodule