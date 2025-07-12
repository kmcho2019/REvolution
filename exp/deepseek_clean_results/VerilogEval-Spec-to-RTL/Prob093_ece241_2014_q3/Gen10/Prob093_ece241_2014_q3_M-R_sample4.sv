module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab = 00 column
    assign mux_in[0] = c | d;  // 0 only when c=0 and d=0
    
    // ab = 01 column
    assign mux_in[1] = 1'b0;    // always 0
    
    // ab = 11 column
    assign mux_in[2] = ~(c ^ d); // 1 when c equals d
    
    // ab = 10 column
    assign mux_in[3] = ~(~c & d); // 0 only when c=0 and d=1

endmodule