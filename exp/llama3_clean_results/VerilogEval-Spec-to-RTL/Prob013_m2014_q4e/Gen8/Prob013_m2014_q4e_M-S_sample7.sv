module TopModule(
    input  in1,
    output out,
    input  in2
);
assign out = ~(in1 | in2);
endmodule