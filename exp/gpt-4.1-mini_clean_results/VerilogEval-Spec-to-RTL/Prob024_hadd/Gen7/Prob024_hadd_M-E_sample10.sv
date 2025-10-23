module XORGate (
    input  x,
    input  y,
    output z
);
assign z = x ^ y;
endmodule

module ANDGate (
    input  x,
    input  y,
    output z
);
assign z = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

XORGate xor_inst (
    .x(a),
    .y(b),
    .z(sum)
);

ANDGate and_inst (
    .x(a),
    .y(b),
    .z(cout)
);

endmodule