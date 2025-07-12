module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum output using mux implementation
    assign sum = a ? ~b : b;
    
    // Carry output using NAND + inverter
    wire nand_out;
    assign nand_out = ~(a & b);
    assign cout = ~nand_out;
endmodule