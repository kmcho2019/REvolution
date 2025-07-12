module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // 32-bit shift register (combinational shifting)
    wire [31:0] shift_reg;
    
    // Shift in all inputs followed by 2'b11
    assign shift_reg = {a, b, c, d, e, f, 2'b11} << 0;  // The shift is conceptual
    
    // Split the shift register into outputs
    assign w = shift_reg[31:24];
    assign x = shift_reg[23:16];
    assign y = shift_reg[15:8];
    assign z = shift_reg[7:0];

endmodule