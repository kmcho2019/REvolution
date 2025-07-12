module TopModule (
    input p1a,p1b,p1c, p1d,p1e,p1f,  // Group related inputs
    input p2a,p2b, p2c,p2d,          // Separate p2 inputs
    output p1y,p2y
);
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);  // Explicit grouping
    assign p2y = (p2a & p2b) | (p2c & p2d);              // Clear 2-input ANDs
endmodule