// TopModule: A novel implementation of the required functionality using a K-map
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Expression for q obtained from K-map simplification
    assign q = (~a & ~b) | (~a & c) | (~b & d) | (b & c);

endmodule