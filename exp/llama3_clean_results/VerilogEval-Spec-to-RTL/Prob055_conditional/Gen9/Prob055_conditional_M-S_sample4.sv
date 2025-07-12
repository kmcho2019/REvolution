module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Compare a and b, and c and d
    wire [7:0] ab_min, cd_min;
    assign ab_min = (a < b)? a : b;
    assign cd_min = (c < d)? c : d;

    // The minimum value is the result of the final comparison
    assign min = (ab_min < cd_min)? ab_min : cd_min;

endmodule