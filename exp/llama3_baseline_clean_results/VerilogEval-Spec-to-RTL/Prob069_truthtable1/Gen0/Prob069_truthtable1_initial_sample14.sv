module TopModule(x3, x2, x1, f);
    input x3;
    input x2;
    input x1;
    output f;

    assign f = (x2) | (x3 & x1);
endmodule