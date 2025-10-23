module TopModule (
    input  a,
    input  b,
    output wire sum,
    output wire cout
);

assign {cout, sum} = {a & b, a ^ b};

endmodule