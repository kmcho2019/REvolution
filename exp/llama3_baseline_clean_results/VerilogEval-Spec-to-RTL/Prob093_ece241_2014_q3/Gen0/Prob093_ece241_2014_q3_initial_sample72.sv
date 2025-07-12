module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    // Direct assignments based on the K-map analysis
    assign mux_in[0] = d; // ab = 00
    assign mux_in[1] = ~c; // ab = 01, considering the need for 'c'' (complement of 'c')
    assign mux_in[2] = d; // ab = 10
    assign mux_in[3] = (c || d); // ab = 11, implementing 'c + d'
endmodule