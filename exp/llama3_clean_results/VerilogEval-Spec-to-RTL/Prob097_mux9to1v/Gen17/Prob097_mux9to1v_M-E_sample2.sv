module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

// Level 1: Select between pairs of input signals
wire [15:0] ab, cd, ef, gh, ij;
assign ab = (sel[0] == 0) ? a : b;
assign cd = (sel[0] == 0) ? c : d;
assign ef = (sel[0] == 0) ? e : f;
assign gh = (sel[0] == 0) ? g : h;
assign ij = (sel[0] == 0) ? i : 16'hFFFF;

// Level 2: Select between the outputs of the first level
wire [15:0] abcd, efgh;
assign abcd = (sel[1] == 0) ? ab : cd;
assign efgh = (sel[1] == 0) ? ef : gh;

// Level 3: Produce the final output
assign out = (sel[2] == 0) ? abcd : efgh;

// Set output to '1' for unused cases (sel=9 to 15)
assign out = (sel >= 4'd9) ? 16'hFFFF : out;

endmodule