module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // 32-bit shift register
    reg [31:0] shift_reg;

    // Load all inputs into the shift register with 2'b11 at LSB
    always @(*) begin
        shift_reg = {a, b, c, d, e, f, 2'b11};
    end

    // Extract 8-bit outputs from the shift register
    assign w = shift_reg[31:24];
    assign x = shift_reg[23:16];
    assign y = shift_reg[15:8];
    assign z = shift_reg[7:0];

endmodule