module TopModule(
    input  in,
    output out
);
    assign out = ~in; // The ~ operator is used for bitwise NOT in Verilog
endmodule