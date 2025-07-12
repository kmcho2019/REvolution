module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation of K-map (checkerboard pattern):
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
    */
    
    // Buffered inputs for better signal integrity
    wire a_buf, b_buf, c_buf, d_buf;
    buf(a_buf, a);
    buf(b_buf, b);
    buf(c_buf, c);
    buf(d_buf, d);
    
    // Explicit output wire declaration
    wire out_wire;
    
    // synthesis attribute use_xor_chain of this module is "yes"
    // synthesis attribute max_delay of out_wire is 0.5ns
    assign out_wire = a_buf ^ b_buf ^ c_buf ^ d_buf;
    
    // Output buffer
    buf(out, out_wire);

endmodule