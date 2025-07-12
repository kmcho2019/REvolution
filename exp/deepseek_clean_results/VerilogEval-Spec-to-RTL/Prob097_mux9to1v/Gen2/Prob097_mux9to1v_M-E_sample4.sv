module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

wire a_sel = (sel == 4'd0);
wire b_sel = (sel == 4'd1);
wire c_sel = (sel == 4'd2);
wire d_sel = (sel == 4'd3);
wire e_sel = (sel == 4'd4);
wire f_sel = (sel == 4'd5);
wire g_sel = (sel == 4'd6);
wire h_sel = (sel == 4'd7);
wire i_sel = (sel == 4'd8);
wire default_sel = (sel > 4'd8);

assign out = (a & {16{a_sel}}) | 
             (b & {16{b_sel}}) | 
             (c & {16{c_sel}}) | 
             (d & {16{d_sel}}) | 
             (e & {16{e_sel}}) | 
             (f & {16{f_sel}}) | 
             (g & {16{g_sel}}) | 
             (h & {16{h_sel}}) | 
             (i & {16{i_sel}}) | 
             ({16{default_sel}});

endmodule