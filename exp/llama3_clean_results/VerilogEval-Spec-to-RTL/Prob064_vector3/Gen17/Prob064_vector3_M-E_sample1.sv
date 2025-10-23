module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z
);

    logic [15:0] ab;
    logic [15:0] cd;
    logic [15:0] ef;
    logic [31:0] abcdef;

    assign ab = {a, b};
    assign cd = {c, d};
    assign ef = {e, f};
    assign abcdef = {ab, cd, ef};
    assign w = abcdef[31:24];
    assign x = abcdef[23:16];
    assign y = abcdef[15:8];
    assign z = {abcdef[7:0], 2'b11};

endmodule