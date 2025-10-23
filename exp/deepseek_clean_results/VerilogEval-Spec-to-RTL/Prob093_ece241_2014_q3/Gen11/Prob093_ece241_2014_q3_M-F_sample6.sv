module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab = 00 column (matches K-map: 0 when cd=00, 1 otherwise)
    assign mux_in[0] = c | d;
    
    // ab = 01 column (always 0)
    assign mux_in[1] = 1'b0;
    
    // ab = 11 column (1 when c=1, regardless of d)
    assign mux_in[2] = c;
    
    // ab = 10 column (0 only when c=0 and d=1)
    assign mux_in[3] = ~(~c & d);

endmodule