module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    reg [31:0] shift_reg;

    always @(a, b, c, d, e, f) begin
        shift_reg = {a, b, c, d, e, f, 2'b11};
    end

    assign w = shift_reg[31:24];
    assign x = shift_reg[23:16];
    assign y = shift_reg[15:8];
    assign z = {shift_reg[7:0], 2'b00};

endmodule