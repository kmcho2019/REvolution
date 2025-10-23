module TopModule(
    input x,
    input y,
    output reg z
);

always @(*)
    z = x && !y;

endmodule