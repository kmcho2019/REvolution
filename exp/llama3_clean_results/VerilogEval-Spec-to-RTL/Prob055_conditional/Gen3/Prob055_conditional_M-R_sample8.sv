module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Define a function to find the minimum of two numbers
    wire [7:0] min_ab;
    assign min_ab = (a < b) ? a : b;

    // Find the minimum of the first three numbers
    wire [7:0] min_abc;
    assign min_abc = (min_ab < c) ? min_ab : c;

    // Finally, find the minimum of all four numbers
    assign min = (min_abc < d) ? min_abc : d;

endmodule