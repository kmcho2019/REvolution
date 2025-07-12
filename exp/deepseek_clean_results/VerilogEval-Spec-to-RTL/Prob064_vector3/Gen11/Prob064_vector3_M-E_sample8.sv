module TopModule (
    input [4:0] a,
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

    reg [31:0] shift_reg;

    always @* begin
        // Load inputs and padding into shift register
        shift_reg = {2'b11, f, e, d, c, b, a};
        
        // Rotate right by 2 bits to position padding at LSBs
        shift_reg = {shift_reg[1:0], shift_reg[31:2]};
    end

    // Tap outputs from the shift register
    assign w = shift_reg[31:24];
    assign x = shift_reg[23:16];
    assign y = shift_reg[15:8];
    assign z = shift_reg[7:0];

endmodule