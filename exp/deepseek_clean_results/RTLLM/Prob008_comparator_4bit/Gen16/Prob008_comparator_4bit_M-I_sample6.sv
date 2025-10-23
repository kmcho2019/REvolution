module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Fast parallel equality check
    wire equal = (A == B);
    
    // Optimized magnitude comparison using balanced tree
    wire [3:0] diff = A - B;
    wire greater = ~diff[3] & (|diff[2:0] | diff[3]);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & ~diff[3];
    assign A_less = ~equal & diff[3];

endmodule