module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab = 00: 1 when c OR d is true (covers all 1s in column)
    assign mux_in[0] = c | d;
    
    // ab = 01: always 0
    assign mux_in[1] = 1'b0;
    
    // ab = 11: 1 only when both c AND d are true
    assign mux_in[2] = c & d;
    
    // ab = 10: 1 when NOT d OR c (covers all 1s in column)
    assign mux_in[3] = ~d | c;

endmodule