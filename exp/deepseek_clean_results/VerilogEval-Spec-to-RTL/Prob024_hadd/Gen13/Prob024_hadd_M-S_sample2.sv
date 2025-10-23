module TopModule (
    input  a, b,
    output sum, cout
);

    assign {cout, sum} = {a & b, a ^ b};

endmodule