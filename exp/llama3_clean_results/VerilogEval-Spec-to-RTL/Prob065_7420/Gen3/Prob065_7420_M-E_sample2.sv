// Define a reusable module for a parameterizable NAND gate
module ParamNAND(
    input [3:0] inputs,
    output y
);

always_comb begin
    case (inputs)
        4'b0000: y = 1'b1;
        4'b0001: y = 1'b1;
        4'b0010: y = 1'b1;
        4'b0011: y = 1'b1;
        4'b0100: y = 1'b1;
        4'b0101: y = 1'b1;
        4'b0110: y = 1'b1;
        4'b0111: y = 1'b0;
        4'b1000: y = 1'b1;
        4'b1001: y = 1'b1;
        4'b1010: y = 1'b1;
        4'b1011: y = 1'b0;
        4'b1100: y = 1'b1;
        4'b1101: y = 1'b0;
        4'b1110: y = 1'b0;
        4'b1111: y = 1'b0;
        default: y = 1'b0;
    endcase
end

endmodule

// Instantiate the ParamNAND module twice within the TopModule
module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

ParamNAND nand1(
   .inputs({p1d, p1c, p1b, p1a}),
   .y(p1y)
);

ParamNAND nand2(
   .inputs({p2d, p2c, p2b, p2a}),
   .y(p2y)
);

endmodule