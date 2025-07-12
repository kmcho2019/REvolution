module TopModule(
    input  in1,
    input  in2,
    output out
);
wire not_in1, not_in2;
assign not_in1 = ~in1;
assign not_in2 = ~in2;
assign out = not_in1 & not_in2;
endmodule