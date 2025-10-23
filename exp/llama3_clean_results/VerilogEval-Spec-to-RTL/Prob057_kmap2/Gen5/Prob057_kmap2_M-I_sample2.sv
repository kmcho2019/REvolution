module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Corrected and optimized implementation based on the Karnaugh map
assign out = (~a & ~b & c & ~d) | 
             (~a & b & c) | 
             (a & ~b & ~c) | 
             (a & d);

// This expression covers all '1's in the Karnaugh map with minimal terms,
// optimizing the design for better PPA metrics.

endmodule