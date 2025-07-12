module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing logic for ab = 00 (mux_in[0])
    assign mux_in[0] = (~c && d);  

    // Implementing logic for ab = 01 (mux_in[1])
    assign mux_in[1] = (c && ~d);  

    // Logic for mux_in[2] (ab = 11)
    assign mux_in[2] = c;  

    // Logic for mux_in[3] (ab = 10)
    assign mux_in[3] = d;  

endmodule