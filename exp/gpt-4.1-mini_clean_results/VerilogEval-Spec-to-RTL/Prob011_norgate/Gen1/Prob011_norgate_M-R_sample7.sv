module TopModule (
    input  a,
    input  b,
    output out
);

wire or_result;

assign or_result = a | b;
assign out = ~or_result;

endmodule