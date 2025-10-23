module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    assign mux_in[0] = 0;
    assign mux_in[1] = c;
    assign mux_in[2] = d;
    assign mux_in[3] = c ? d : d; // equivalent to a 2-to-1 mux with c as the selector and d as both inputs, or just 'd' in this context
endmodule