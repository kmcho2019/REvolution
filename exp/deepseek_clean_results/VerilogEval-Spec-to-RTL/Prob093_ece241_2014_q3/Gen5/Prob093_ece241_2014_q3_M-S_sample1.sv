module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[3] (ab=10): ~d | c
    assign mux_in[3] = d ? c : 1'b1;
    
    // mux_in[2] (ab=11): c & d
    assign mux_in[2] = c & d;
    
    // mux_in[1] (ab=01): constant 0
    assign mux_in[1] = 1'b0;
    
    // mux_in[0] (ab=00): c | d
    assign mux_in[0] = c | d;

endmodule