module TopModule(
    input in,
    output out
);
buff1 u_buf(out, in);
endmodule

module buff1(out, in);
output out;
input in;
assign out = in;
endmodule