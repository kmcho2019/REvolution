module TopModule(clk, in, out);
    input clk;
    input in;
    output out;
    reg out;

    initial out = 0;

    always @(posedge clk)
        out <= in ^ out;

endmodule