module TopModule(
    input  a,
    input  b,
    output q
);

    // Use the logical AND operator to directly implement the AND gate functionality.
    assign q = a & b;

endmodule