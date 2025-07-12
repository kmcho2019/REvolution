module TopModule (
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

    wire [14:0] first_half;
    wire [14:0] second_half;
    wire [31:0] combined;

    assign first_half  = {a, b, c};       // 5+5+5 = 15 bits
    assign second_half = {d, e, f};       // 5+5+5 = 15 bits
    assign combined    = {first_half, second_half, 2'b11}; // 15+15+2 = 32 bits

    assign {w, x, y, z} = combined;

endmodule