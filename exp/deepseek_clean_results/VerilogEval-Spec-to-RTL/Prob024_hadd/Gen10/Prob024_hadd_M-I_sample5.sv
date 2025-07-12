module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Using single assign statement for both outputs
    assign {cout, sum} = {a & b, a ^ b};

endmodule