module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(ena or d)
    if (ena)
        q = d;

endmodule