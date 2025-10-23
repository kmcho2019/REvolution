module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // ab=00 case: ~c OR d
    assign mux_in[0] = (~c) | d;
    
    // ab=01 case: constant 0
    assign mux_in[1] = 1'b0;
    
    // ab=11 case: c AND d
    assign mux_in[2] = c & d;
    
    // ab=10 case: c OR ~d
    assign mux_in[3] = c | (~d);

endmodule