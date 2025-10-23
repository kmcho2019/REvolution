module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_d = ~d;
    
    // mux_in[0] (ab=00): 1 when cd=00 or 10 → ~d
    assign mux_in[0] = not_d;
    
    // mux_in[1] (ab=01): always 0
    assign mux_in[1] = 1'b0;
    
    // mux_in[2] (ab=11): 1 when cd=00 or 11 → mux selects ~d when c=0, d when c=1
    assign mux_in[2] = c ? d : not_d;
    
    // mux_in[3] (ab=10): 1 when cd=00,10,11 → ~d or c
    assign mux_in[3] = not_d | c;

endmodule