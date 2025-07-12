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
    output reg [15:0] out
);

wire [15:0] ab, cd, ef, gh, i_all;
assign ab = sel[0] ? b : a;
assign cd = sel[0] ? d : c;
assign ef = sel[0] ? f : e;
assign gh = sel[0] ? h : g;
assign i_all = 16'hFFFF;

wire [15:0] ab_cd, ef gh, i_all_gh;
assign ab_cd = sel[1] ? cd : ab;
assign ef_gh = sel[1] ? gh : ef;

wire [15:0] ab_cd_efgh, i_all_abcd;
assign ab_cd_efgh = sel[2] ? ef_gh : ab_cd;
assign i_all_abcd = sel[2] ? i_all : ab_cd;

assign out = sel[3] ? i_all_abcd : ab_cd_efgh;

endmodule