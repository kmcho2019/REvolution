module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output reg [7:0] w,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg [7:0] z
);

    reg [31:0] shift_reg;
    integer i;

    always @(*) begin
        // Parallel load of inputs
        shift_reg = {a, b, c, d, e, f, 2'b11};
        
        // Shift out to outputs
        w = shift_reg[31:24];
        x = shift_reg[23:16];
        y = shift_reg[15:8];
        z = shift_reg[7:0];
    end

endmodule