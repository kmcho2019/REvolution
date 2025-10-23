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

// First level muxes (3 groups of 3 inputs)
wire [15:0] l1_mux0_out, l1_mux1_out, l1_mux2_out;

// Second level mux (selects between first level outputs)
wire [15:0] l2_mux_out;

// Control signals for each level
wire l1_sel0 = (sel[1:0] == 2'b00) && (sel[3:2] == 2'b00);
wire l1_sel1 = (sel[1:0] == 2'b01) && (sel[3:2] == 2'b00);
wire l1_sel2 = (sel[1:0] == 2'b10) && (sel[3:2] == 2'b00);

wire l2_sel0 = (sel[3:2] == 2'b01);
wire l2_sel1 = (sel[3:2] == 2'b10);

// First level muxes
assign l1_mux0_out = l1_sel0 ? a : (l1_sel1 ? b : (l1_sel2 ? c : 16'b0));
assign l1_mux1_out = l1_sel0 ? d : (l1_sel1 ? e : (l1_sel2 ? f : 16'b0));
assign l1_mux2_out = l1_sel0 ? g : (l1_sel1 ? h : (l1_sel2 ? i : 16'b0));

// Second level mux
assign l2_mux_out = l2_sel0 ? l1_mux0_out : (l2_sel1 ? l1_mux1_out : l1_mux2_out);

// Final output with default handling
assign out = (sel < 9) ? l2_mux_out : 16'hFFFF;

endmodule