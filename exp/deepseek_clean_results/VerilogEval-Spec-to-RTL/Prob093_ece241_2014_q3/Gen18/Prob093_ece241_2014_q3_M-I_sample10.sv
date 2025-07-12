module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab = 00 cases: 0 when cd=00, 1 otherwise → c OR d
    assign mux_in[0] = c | d;
    
    // ab = 01 cases: always 0
    assign mux_in[1] = 1'b0;
    
    // ab = 11 cases: 1 only when cd=11 → c AND d
    assign mux_in[2] = c & d;
    
    // ab = 10 cases: 1 when cd=00,11,10; 0 when cd=01 → ~d OR (c & d)
    assign mux_in[3] = ~d | (c & d);

endmodule