module TopModule(
    input  in1,
    input  in2,
    output out
);

wire sel;

assign sel = in1 | in2;
assign out = (in1 == 1'b0) & (in2 == 1'b0);

endmodule