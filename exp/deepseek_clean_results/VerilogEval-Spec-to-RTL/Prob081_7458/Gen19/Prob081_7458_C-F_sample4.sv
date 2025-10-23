module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate wires with descriptive names
    wire p1_first_and = p1a & p1b & p1c;
    wire p1_second_and = p1d & p1e & p1f;
    wire p2_first_and = p2a & p2b;
    wire p2_second_and = p2c & p2d;

    // Output assignments
    assign p1y = p1_first_and | p1_second_and;
    assign p2y = p2_first_and | p2_second_and;
endmodule