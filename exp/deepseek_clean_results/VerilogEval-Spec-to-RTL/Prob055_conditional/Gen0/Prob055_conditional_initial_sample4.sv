module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_abc;

    // Compare a and b
    assign min_ab = (a < b) ? a : b;

    // Compare min_ab and c
    assign min_abc = (min_ab < c) ? min_ab : c;

    // Compare min_abc and d to get the final minimum
    assign min = (min_abc < d) ? min_abc : d;

endmodule