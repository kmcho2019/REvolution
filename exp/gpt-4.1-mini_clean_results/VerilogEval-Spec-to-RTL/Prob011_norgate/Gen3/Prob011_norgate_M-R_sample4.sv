module TopModule (
    input a,
    input b,
    output out
);
    wire nand_out;
    assign nand_out = ~(a & b);   // NAND of a and b
    assign out = ~(~nand_out & 1'b1); // Invert nand_out with masking for clarity (equivalent to NOR)
endmodule