module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = 1 when c=1 and d=0
    assign mux_in[0] = (c & ~d) ? 1'b1 : 1'b0;
    
    // mux_in[1] = 1 when c=0 and d=0
    assign mux_in[1] = (~c & ~d) ? 1'b1 : 1'b0;
    
    // mux_in[2] = 1 when c=d
    assign mux_in[2] = (c == d) ? 1'b1 : 1'b0;
    
    // mux_in[3] = 1 when not (c=0 and d=1)
    assign mux_in[3] = (~c & d) ? 1'b0 : 1'b1;

endmodule