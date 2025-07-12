module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Group inputs into vectors for cleaner operations
    wire [2:0] p1_group1 = {p1a, p1b, p1c};
    wire [2:0] p1_group2 = {p1d, p1e, p1f};
    wire [1:0] p2_group1 = {p2a, p2b};
    wire [1:0] p2_group2 = {p2c, p2d};

    // Parameterized AND function using reduction operator
    function automatic logic param_and(input logic [2:0] inputs);
        param_and = &inputs;
    endfunction

    // Calculate p1y using vectorized operations
    assign p1y = param_and(p1_group1) | param_and(p1_group2);

    // Calculate p2y using direct bitwise operations
    assign p2y = (&p2_group1) | (&p2_group2);
endmodule