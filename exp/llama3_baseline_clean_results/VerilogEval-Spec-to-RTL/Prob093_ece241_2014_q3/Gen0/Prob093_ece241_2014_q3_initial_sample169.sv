module TopModule(c, d, mux_in);
    input c;
    input d;
    output [3:0] mux_in;

    assign mux_in[0] = d ? 1 : (c ? 1 : 0);  // Region 00
    assign mux_in[1] = d ? c : 0;           // Region 01
    assign mux_in[2] = d ? c : 1;           // Region 11
    assign mux_in[3] = c ? 1 : d;           // Region 10
endmodule