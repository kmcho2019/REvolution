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

// First level of muxes (4 pairs)
wire [15:0] mux1_0, mux1_1, mux1_2, mux1_3;
assign mux1_0 = (sel[0]) ? b : a;
assign mux1_1 = (sel[0]) ? d : c;
assign mux1_2 = (sel[0]) ? f : e;
assign mux1_3 = (sel[0]) ? h : g;

// Second level of muxes (2 pairs)
wire [15:0] mux2_0, mux2_1;
assign mux2_0 = (sel[1]) ? mux1_1 : mux1_0;
assign mux2_1 = (sel[1]) ? mux1_3 : mux1_2;

// Third level mux
wire [15:0] mux3;
assign mux3 = (sel[2]) ? mux2_1 : mux2_0;

// Final selection between tree output and input 'i'
wire [15:0] tree_out;
assign tree_out = (sel[3]) ? i : mux3;

// Handle invalid cases (sel > 8) by OR-ing with mask
wire invalid_sel = (sel > 4'd8);
wire [15:0] default_mask = {16{invalid_sel}};
assign out = tree_out | default_mask;

endmodule