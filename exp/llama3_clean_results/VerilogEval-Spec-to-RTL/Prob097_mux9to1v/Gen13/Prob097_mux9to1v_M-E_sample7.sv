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

wire [15:0] mid1, mid2, mid3, mid4;

assign mid1 = (sel[3]) ? (sel[2]) ? (sel[1]) ? (sel[0]) ? i : h : (sel[0]) ? g : f : (sel[1]) ? (sel[0]) ? e : d : (sel[0]) ? c : b;
assign mid2 = (sel[3]) ? (sel[2]) ? 16'hFFFF : 16'hFFFF : (sel[2]) ? 16'hFFFF : 16'hFFFF;
assign mid3 = (sel[3]) ? 16'hFFFF : mid1;
assign mid4 = (sel[3:2]) ? 16'hFFFF : (sel[1]) ? (sel[0]) ? e : d : (sel[0]) ? c : b;

assign out = (sel[3:1]) ? 16'hFFFF : (sel[0]) ? mid4 : mid1;

endmodule