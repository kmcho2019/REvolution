module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Intermediate comparison vectors for each input
    wire [4:0] cmp_a = {1'b1,    a ~^ b, a ~^ c, a ~^ d, a ~^ e};
    wire [4:0] cmp_b = {b ~^ a, 1'b1,    b ~^ c, b ~^ d, b ~^ e};
    wire [4:0] cmp_c = {c ~^ a, c ~^ b, 1'b1,    c ~^ d, c ~^ e};
    wire [4:0] cmp_d = {d ~^ a, d ~^ b, d ~^ c, 1'b1,    d ~^ e};
    wire [4:0] cmp_e = {e ~^ a, e ~^ b, e ~^ c, e ~^ d, 1'b1};

    // Concatenate all comparison vectors
    assign out = {cmp_a, cmp_b, cmp_c, cmp_d, cmp_e};

endmodule