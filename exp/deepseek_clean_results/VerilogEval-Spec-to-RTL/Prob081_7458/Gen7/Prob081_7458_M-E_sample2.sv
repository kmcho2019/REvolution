module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Internal signals for AND results
    wire and3_1 = &{p1a, p1b, p1c};
    wire and3_2 = &{p1d, p1e, p1f};
    wire and2_1 = &{p2a, p2b};
    wire and2_2 = &{p2c, p2d};

    // Output assignments
    assign p1y = |{and3_1, and3_2};
    assign p2y = |{and2_1, and2_2};

endmodule