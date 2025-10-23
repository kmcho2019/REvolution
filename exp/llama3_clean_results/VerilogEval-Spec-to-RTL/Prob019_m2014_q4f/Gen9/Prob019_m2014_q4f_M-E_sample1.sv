module TopModule(
    input in1,
    input in2,
    output out
);

assign out = in2? ~in1 : in1;

endmodule