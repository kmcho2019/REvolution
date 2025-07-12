module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    wire ab00, ab01, ab11, ab10;

    assign ab00 = d;
    assign ab01 = c? ~d : 0;
    assign ab11 = c? d : 0;
    assign ab10 = c? 1 : 0;

    assign mux_in[0] = ab00;
    assign mux_in[1] = ab01;
    assign mux_in[2] = ab11;
    assign mux_in[3] = ab10;

endmodule