module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    // Implementing the function z = x & ~y,
    // which is logically equivalent to (x ^ y) & x,
    // to optimize power and area by avoiding XOR gate.
    always @(*) begin
        z = x & ~y;
    end
endmodule