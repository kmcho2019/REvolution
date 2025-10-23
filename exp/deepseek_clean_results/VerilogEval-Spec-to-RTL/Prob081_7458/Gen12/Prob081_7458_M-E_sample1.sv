module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Temporary vectors for grouped inputs
    wire [2:0] p1_group1 = {p1a, p1b, p1c};
    wire [2:0] p1_group2 = {p1d, p1e, p1f};
    wire [1:0] p2_group1 = {p2a, p2b};
    wire [1:0] p2_group2 = {p2c, p2d};

    // Output logic using reduction operators
    assign p1y = (&p1_group1) | (&p1_group2);
    assign p2y = (&p2_group1) | (&p2_group2);
endmodule