module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

wire [1:0] result;
assign result = {a & b, a ^ b};

assign cout = result[1];
assign sum = result[0];

endmodule