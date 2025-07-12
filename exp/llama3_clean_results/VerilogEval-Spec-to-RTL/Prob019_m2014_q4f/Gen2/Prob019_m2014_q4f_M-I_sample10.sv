module TopModule(
    input in1,
    input in2,
    output out
);

wire in2_buf;
assign in2_buf = ~in2;
assign out = in1 & in2_buf;

endmodule