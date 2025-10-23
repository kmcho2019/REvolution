module TopModule(
    input a,
    input b,
    input c,
    output out
);

wire or_result;
assign or_result = b | c;
assign out = a? 1'b1 : or_result;

endmodule