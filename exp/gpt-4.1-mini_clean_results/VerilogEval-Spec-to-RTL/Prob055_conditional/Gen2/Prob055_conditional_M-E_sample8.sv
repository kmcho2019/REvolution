module Comparator8 (
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] min_out
);
    assign min_out = (x < y) ? x : y;
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Pack inputs into an array for easy indexing
    wire [7:0] vals [0:3];
    assign vals[0] = a;
    assign vals[1] = b;
    assign vals[2] = c;
    assign vals[3] = d;

    // Intermediate wires for reduction stages
    wire [7:0] stage1 [0:1]; // two comparators reduce 4 inputs to 2 outputs
    wire [7:0] stage2;       // final comparator output (minimum)

    // First stage comparators: compare pairs (0,1) and (2,3)
    Comparator8 comp0 (
        .x(vals[0]),
        .y(vals[1]),
        .min_out(stage1[0])
    );

    Comparator8 comp1 (
        .x(vals[2]),
        .y(vals[3]),
        .min_out(stage1[1])
    );

    // Final stage comparator: compare the two stage1 results
    Comparator8 comp2 (
        .x(stage1[0]),
        .y(stage1[1]),
        .min_out(stage2)
    );

    assign min = stage2;

endmodule