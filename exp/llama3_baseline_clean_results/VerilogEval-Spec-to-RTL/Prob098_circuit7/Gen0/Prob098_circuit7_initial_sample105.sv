module TopModule(clk, a, q);
    input clk, a;
    output q;
    reg q;

    always @(posedge clk)
        if (a) q = ~q;
        else q = q;

    // initialize q
    initial q = 1;

endmodule