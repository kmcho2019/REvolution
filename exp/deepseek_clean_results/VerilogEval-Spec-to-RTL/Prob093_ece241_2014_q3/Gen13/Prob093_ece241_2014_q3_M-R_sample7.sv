module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: 0 when cd=00, else 1
    assign mux_in[0] = ~(~c & d);
    
    // mux_in[1]: always 0
    assign mux_in[1] = 1'b0;
    
    // mux_in[2]: 1 only when cd=11
    assign mux_in[2] = c & d;
    
    // mux_in[3]: same as mux_in[0] pattern
    assign mux_in[3] = ~(~c & d);

endmodule