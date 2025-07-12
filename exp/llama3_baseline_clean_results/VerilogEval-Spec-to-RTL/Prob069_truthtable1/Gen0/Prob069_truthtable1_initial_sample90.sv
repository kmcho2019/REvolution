module TopModule(x3, x2, x1, f);
    input x3, x2, x1;
    output f;
    assign f = x3 ^ x2 ^ x1;
endmodule