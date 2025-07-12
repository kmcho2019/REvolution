module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Implementing the logic for each output based on the Karnaugh map
    // For ab=00, the output is 0
    assign mux_in[0] = 0;

    // For ab=01, the output is 0
    assign mux_in[1] = 0;

    // For ab=11, the output is dependent on c and d
    assign mux_in[2] = (c && !d) || (!c && d);

    // For ab=10, the output is 1
    assign mux_in[3] = (c || !d);
endmodule