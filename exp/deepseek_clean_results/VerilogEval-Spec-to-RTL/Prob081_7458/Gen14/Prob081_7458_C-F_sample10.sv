module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // p1y: OR of two 3-input AND gates
    assign p1y = (p1a & p1b & p1c)  // First 3-input AND
               | (p1d & p1e & p1f); // Second 3-input AND
    
    // p2y: OR of two 2-input AND gates
    assign p2y = (p2a & p2b)      // First 2-input AND
               | (p2c & p2d);     // Second 2-input AND
endmodule