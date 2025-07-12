module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire [3:0] mux_in;
    
    assign mux_in[0] = ~a & ~b;  // cd = 00
    assign mux_in[1] = ~a & b;   // cd = 01
    assign mux_in[2] = a & ~b;   // cd = 10
    assign mux_in[3] = a & b;    // cd = 11
    
    assign out = (c & d) ? mux_in[3] :
                 (c & ~d) ? mux_in[2] :
                 (~c & d) ? mux_in[1] :
                 mux_in[0];

endmodule