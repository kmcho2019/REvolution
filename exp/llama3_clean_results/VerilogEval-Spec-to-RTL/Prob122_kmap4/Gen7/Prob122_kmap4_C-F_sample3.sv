module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire same_cd; // Condition for c and d being the same
    wire diff_ab; // Condition for a and b being different
    wire diff_cd; // Condition for c and d being different
    wire same_ab; // Condition for a and b being the same

    assign same_cd = (c == d);
    assign diff_ab = (a != b);
    assign diff_cd = (c != d);
    assign same_ab = (a == b);

    assign out = (same_cd & diff_ab) | (diff_cd & same_ab);

endmodule