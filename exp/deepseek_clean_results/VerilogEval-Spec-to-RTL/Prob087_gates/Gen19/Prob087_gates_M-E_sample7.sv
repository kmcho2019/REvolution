module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Create 2-bit select signal
    wire [1:0] sel = {a, b};

    // Each output is a 4:1 mux implementing its truth table
    assign out_and = (sel == 2'b11) ? 1'b1 : 1'b0;
    assign out_or = (sel != 2'b00) ? 1'b1 : 1'b0;
    assign out_xor = (sel == 2'b01 || sel == 2'b10) ? 1'b1 : 1'b0;
    assign out_nand = (sel != 2'b11) ? 1'b1 : 1'b0;
    assign out_nor = (sel == 2'b00) ? 1'b1 : 1'b0;
    assign out_xnor = (sel == 2'b00 || sel == 2'b11) ? 1'b1 : 1'b0;
    assign out_anotb = (sel == 2'b10) ? 1'b1 : 1'b0;

endmodule