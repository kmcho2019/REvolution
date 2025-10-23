module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00: 0 when cd=00, else 1
    assign mux_in[0] = c | d;
    
    // ab=01: always 0
    assign mux_in[1] = 1'b0;
    
    // ab=11: output follows c
    assign mux_in[2] = c;
    
    // ab=10: 0 only when cd=01 (c=0,d=1)
    assign mux_in[3] = ~(~c & d);

endmodule