module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Compare a and b to find the minimum
    wire [7:0] min_ab;
    assign min_ab = (a < b) ? a : b;

    // Compare min_ab and c to find the minimum
    wire [7:0] min_abc;
    assign min_abc = (min_ab < c) ? min_ab : c;

    // Compare min_abc and d to find the final minimum
    assign min = (min_abc < d) ? min_abc : d;

endmodule