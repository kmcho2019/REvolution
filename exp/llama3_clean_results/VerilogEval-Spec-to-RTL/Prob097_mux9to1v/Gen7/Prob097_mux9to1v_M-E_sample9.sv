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

// First level of multiplexers
wire [15:0] ab, cd, ef, gh;
assign ab  = (sel[0]) ? b : a;
assign cd  = (sel[0]) ? d : c;
assign ef  = (sel[0]) ? f : e;
assign gh  = (sel[0]) ? h : g;

// Second level of multiplexers
wire [15:0] abcd, efgh;
assign abcd = (sel[1]) ? cd : ab;
assign efgh = (sel[1]) ? gh : ef;

// Final multiplexer
wire [15:0] abcd_efgh;
assign abcd_efgh = (sel[2]) ? efgh : abcd;

// For sel >= 9, set output to all '1's
assign out = (sel[3]) ? 16'hFFFF : abcd_efgh;

endmodule