module TopModule(
    input in1,
    input in2,
    output out
);

wire or_out;

assign or_out = in1 | in2;
assign out = ~or_out;

endmodule