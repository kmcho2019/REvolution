module TopModule (
    input [4:0] a,  // 5-bit inputs
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // 32-bit internal shift register
    reg [31:0] shift_reg;

    // Fill the shift register in sequence
    always @(*) begin
        shift_reg = 32'b0;  // Initialize
        shift_reg = shift_reg << 5 | a;  // Shift in a
        shift_reg = shift_reg << 5 | b;  // Shift in b
        shift_reg = shift_reg << 5 | c;  // Shift in c
        shift_reg = shift_reg << 5 | d;  // Shift in d
        shift_reg = shift_reg << 5 | e;  // Shift in e
        shift_reg = shift_reg << 5 | f;  // Shift in f
        shift_reg = shift_reg << 2 | 2'b11;  // Add padding
    end

    // Tap outputs from fixed positions
    assign w = shift_reg[31:24];
    assign x = shift_reg[23:16];
    assign y = shift_reg[15:8];
    assign z = shift_reg[7:0];

endmodule