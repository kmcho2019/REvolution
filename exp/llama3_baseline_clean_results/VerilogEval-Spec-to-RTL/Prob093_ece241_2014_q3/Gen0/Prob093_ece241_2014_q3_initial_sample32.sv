module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Assigning values to mux_in based on the Karnaugh map
    assign mux_in[0] = 0;
    assign mux_in[1] = 0;

    // 2-to-1 multiplexers for mux_in[2] and mux_in[3]
    assign mux_in[2] = (c) ? d : 1;
    assign mux_in[3] = (c) ? d : 1;
endmodule