module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    // Define the comparison signals
    wire comp_ab;
    assign comp_ab = (a < b)? 1'b1 : 1'b0;

    wire comp_cd;
    assign comp_cd = (c < d)? 1'b1 : 1'b0;

    // First level of comparison using MUXes
    wire [7:0] min_ab;
    assign min_ab = comp_ab? a : b;

    wire [7:0] min_cd;
    assign min_cd = comp_cd? c : d;

    // Define the comparison signal for the second level
    wire comp_min;
    assign comp_min = (min_ab < min_cd)? 1'b1 : 1'b0;

    // Second level of comparison using a MUX
    assign min = comp_min? min_ab : min_cd;

endmodule