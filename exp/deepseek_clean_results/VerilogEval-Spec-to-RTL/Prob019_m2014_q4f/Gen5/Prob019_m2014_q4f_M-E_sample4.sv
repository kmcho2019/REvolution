module TopModule (
    input in1,
    input in2,
    output out
);
    // Implement (in1 AND ~in2) using NAND followed by NOT
    wire nand_out;
    
    assign nand_out = ~(in1 & ~in2);
    assign out = ~nand_out;
endmodule