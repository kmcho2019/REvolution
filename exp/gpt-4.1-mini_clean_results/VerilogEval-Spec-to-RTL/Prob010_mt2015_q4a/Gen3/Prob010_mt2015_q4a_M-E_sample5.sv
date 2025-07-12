module TopModule(
    input  x,
    input  y,
    output z
);

wire xor_out;

xor u_xor(.a(x), .b(y), .y(xor_out));
and u_and(.a(xor_out), .b(x), .y(z));

endmodule