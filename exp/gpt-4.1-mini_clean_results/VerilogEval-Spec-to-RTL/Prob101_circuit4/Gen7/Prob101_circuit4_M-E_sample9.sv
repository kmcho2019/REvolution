module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

wire neither_b_nor_c;
assign neither_b_nor_c = ~(b | c); // high only if both b and c are 0
assign q = ~neither_b_nor_c;       // q is high if either b or c is 1

endmodule