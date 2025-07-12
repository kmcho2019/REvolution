module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Implement as 4:1 mux with ab as select
    wire [3:0] mux_in;
    
    // ab=00: ~(c & d)
    assign mux_in[0] = ~(c & d);
    
    // ab=01: ~c | d
    assign mux_in[1] = ~c | d;
    
    // ab=11: c | d
    assign mux_in[2] = c | d;
    
    // ab=10: ~d
    assign mux_in[3] = ~d;
    
    // Final mux
    assign out = (a & b) ? mux_in[2] :
                (a & ~b) ? mux_in[3] :
                (~a & b) ? mux_in[1] :
                mux_in[0];
endmodule