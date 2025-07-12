module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // f is 1 by default (exploiting don't-cares)
    // Only force to 0 in specific cases
    assign f = ~((~x[3] & x[0] & ~x[2]) | (x[3] & ~x[0] & x[2] & ~x[1]));
endmodule