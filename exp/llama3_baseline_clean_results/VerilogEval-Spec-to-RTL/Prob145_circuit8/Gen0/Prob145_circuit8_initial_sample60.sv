module TopModule(
    input clock,
    input a,
    output p,
    output q
);

    reg q_reg;
    initial q_reg = 0;

    always @(posedge clock)
        p <= a;

    always @(posedge clock)
        if (a == 1'b1)
            q_reg <= 1'b1;
    
    always @(negedge clock)
        if (a == 1'b0)
            q_reg <= 1'b0;

    assign q = q_reg;

endmodule