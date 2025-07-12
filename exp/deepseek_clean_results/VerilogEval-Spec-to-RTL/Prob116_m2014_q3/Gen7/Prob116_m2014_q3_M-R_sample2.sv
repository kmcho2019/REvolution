module TopModule(
    input [3:0] x,  // x[3]x[0]x[1]x[2] mapping (assuming x[4] was typo for x[0])
    output f
);
    // Implement the optimized logic expression from K-map analysis
    assign f = (x[3] & ~x[1]) |                // Covers 11_0* and 10_0* cases
               (x[0] & x[1] & x[2]) |          // Covers 01_11 case
               (x[3] & x[0] & ~x[2]);         // Covers 11_01 case

    // Note: All don't-care conditions are optimized to 0 in this implementation
    // The expression covers all mandatory 1s in the K-map while being minimal
endmodule