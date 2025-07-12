module Buffer(
    input  in,
    output out
);
assign out = in;
endmodule

module TopModule(
    input  in,
    output out
);
Buffer buf(in, out);
endmodule