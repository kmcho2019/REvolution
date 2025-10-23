module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output reg p1y, p2y
);
    // Parameterized gate implementation using bitwise operations
    always @(*) begin
        // p1y: OR of two 3-input ANDs using concatenation and reduction
        p1y = (&{p1a, p1b, p1c}) | (&{p1d, p1e, p1f});
        
        // p2y: OR of two 2-input ANDs using bitwise operations
        p2y = (p2a & p2b) | (p2c & p2d);
    end
endmodule