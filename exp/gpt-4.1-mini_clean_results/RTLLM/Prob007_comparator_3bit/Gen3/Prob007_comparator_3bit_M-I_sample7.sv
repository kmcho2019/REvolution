module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire greater;
    wire equal;

    assign greater = (A > B);
    assign equal   = (A == B);

    assign A_greater = greater;
    assign A_equal   = equal;
    assign A_less    = ~(greater | equal);

endmodule