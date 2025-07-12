module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

wire [1:0] result = {a & b, a ^ b};

assign {cout, sum} = result;

endmodule