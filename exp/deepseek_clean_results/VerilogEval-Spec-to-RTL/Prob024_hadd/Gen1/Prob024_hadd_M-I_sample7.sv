module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Most clear and maintainable implementation
    assign {cout, sum} = {a & b, a ^ b};

endmodule