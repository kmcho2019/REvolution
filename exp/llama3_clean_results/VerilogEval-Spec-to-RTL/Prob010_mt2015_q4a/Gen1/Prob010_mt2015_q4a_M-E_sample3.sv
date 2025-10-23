module TopModule(
    input x,
    input y,
    output z
);

assign z = x ? (x ^ y) : 0;

endmodule