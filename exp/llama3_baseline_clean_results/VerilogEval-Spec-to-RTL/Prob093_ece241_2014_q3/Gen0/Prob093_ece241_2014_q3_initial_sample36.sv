module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    assign mux_in[0] = 0;
    assign mux_in[1] = 1'b0; // Changed to 1'b0 as per K-map for ab=01
    assign mux_in[2] = (c) ? 1'b1 : 1'b0;
    assign mux_in[3] = (c) ? 1'b1 : d;

endmodule