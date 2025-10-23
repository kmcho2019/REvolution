module TopModule(x3, x2, x1, f);
    input x3, x2, x1;
    output f;

    assign f = (x2 && (x1 || !x1)) || (x3 && !x2 && x1);
    // Simplify the expression considering x1 || !x1 equals 1
    // assign f = x2 || (x3 && !x2 && x1);
endmodule