module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // reduce_and function
assign out_or  = |in; // reduce_or function
assign out_xor = ^in; // reduce_xor function

endmodule