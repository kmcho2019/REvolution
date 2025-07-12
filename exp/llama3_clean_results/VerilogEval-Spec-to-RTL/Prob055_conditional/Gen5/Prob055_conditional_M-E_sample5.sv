module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Define a comparator module
    module comparator(
        input [7:0] a,
        input [7:0] b,
        output [7:0] min,
        output [7:0] max
    );
        assign min = (a < b) ? a : b;
        assign max = (a < b) ? b : a;
    endmodule

    // Stage 1: Compare a and b, c and d
    wire [7:0] ab_min, ab_max;
    wire [7:0] cd_min, cd_max;
    comparator cmp1(a, b, ab_min, ab_max);
    comparator cmp2(c, d, cd_min, cd_max);

    // Stage 2: Compare the minimum of a and b with the minimum of c and d, 
    //          and the maximum of a and b with the maximum of c and d
    wire [7:0] min_1, max_1;
    wire [7:0] min_2, max_2;
    comparator cmp3(ab_min, cd_min, min_1, min_2);
    comparator cmp4(ab_max, cd_max, max_1, max_2);

    // Stage 3: Compare the minimum of the minimums with the minimum of the maximums
    wire [7:0] min_final;
    comparator cmp5(min_1, min_2, min_final, max_2);

    // Assign the minimum value to the output
    assign min = min_final;

endmodule