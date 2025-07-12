module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, else 1
    assign mux_in[0] = d ? 1'b1 : c;
    
    // ab=01: always 0
    assign mux_in[1] = 1'b0;
    
    // ab=11: 1 when c=1 (matches all cases)
    assign mux_in[2] = c;
    
    // ab=10: 1 except when cd=01
    assign mux_in[3] = c | ~d;

endmodule