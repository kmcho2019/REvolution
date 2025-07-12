module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Parameterized NAND function using concatenation
    function automatic logic nand4(input a, b, c, d);
        return ~(& {a, b, c, d});
    endfunction

    assign p1y = nand4(p1a, p1b, p1c, p1d);
    assign p2y = nand4(p2a, p2b, p2c, p2d);

endmodule