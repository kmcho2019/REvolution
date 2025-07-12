module TopModule (
    // First OR gate inputs (two 3-input ANDs)
    input p1a, p1b, p1c,  // First 3-input AND
    input p1d, p1e, p1f,  // Second 3-input AND
    // Second OR gate inputs (two 2-input ANDs)
    input p2a, p2b,       // First 2-input AND
    input p2c, p2d,       // Second 2-input AND
    output p1y, p2y
);
    // p1y = (p1a AND p1b AND p1c) OR (p1d AND p1e AND p1f)
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
    
    // p2y = (p2a AND p2b) OR (p2c AND p2d)
    assign p2y = (p2a & p2b) | (p2c & p2d);
endmodule