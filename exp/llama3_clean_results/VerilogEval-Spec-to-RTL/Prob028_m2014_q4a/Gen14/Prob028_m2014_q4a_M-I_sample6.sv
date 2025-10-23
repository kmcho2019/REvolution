module TopModule(
    input  d,
    input  ena,
    output wire q
);

assign q = (ena)? d : q;

endmodule