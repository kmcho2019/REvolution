module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,  // Group p1 inputs
    input p2a, p2b, p2c, p2d,            // Group p2 inputs
    output p1y, p2y
);
    // Direct implementation using ternary operators for compact logic
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
    assign p2y = (p2a & p2b) | (p2c & p2d);
endmodule