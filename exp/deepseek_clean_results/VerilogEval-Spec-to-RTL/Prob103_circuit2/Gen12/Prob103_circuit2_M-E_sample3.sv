module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Novel implementation using 4-to-1 mux with parity logic
    wire [3:0] mux_in;
    
    // mux_in[0] = q when a=0, b=0
    assign mux_in[0] = ~(c ^ d);
    
    // mux_in[1] = q when a=0, b=1
    assign mux_in[1] = c ^ ~d;
    
    // mux_in[2] = q when a=1, b=0
    assign mux_in[2] = c ^ ~d;
    
    // mux_in[3] = q when a=1, b=1
    assign mux_in[3] = ~(c ^ d);
    
    // 4-to-1 mux implementation
    assign q = (~a & ~b) ? mux_in[0] :
               (~a &  b) ? mux_in[1] :
               ( a & ~b) ? mux_in[2] :
               mux_in[3];
endmodule