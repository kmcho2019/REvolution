module TopModule(
    input  in1,
    input  in2,
    output out
);
wire sel;
assign sel = in1 | in2;
assign out = (in1 == 1'b0 && in2 == 1'b0) ? 1'b1 : 1'b0;
// alternative using multiplexer (2:1)
// assign out = (sel == 1'b0) ? 1'b1 : 1'b0;
// however, this requires a 2:1 multiplexer which is not directly defined here.
// The expression above directly implements the NOR logic without needing a multiplexor
endmodule