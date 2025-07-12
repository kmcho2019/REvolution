module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Implement all connections using AND gates as buffers
    // (AND with 1'b1 acts as a buffer)
    wire b_buf;
    
    // Buffer for input a
    and(w, a, 1'b1);
    
    // Single buffer for input b that feeds both outputs
    and(b_buf, b, 1'b1);
    assign x = b_buf;
    assign y = b_buf;
    
    // Buffer for input c
    and(z, c, 1'b1);
endmodule