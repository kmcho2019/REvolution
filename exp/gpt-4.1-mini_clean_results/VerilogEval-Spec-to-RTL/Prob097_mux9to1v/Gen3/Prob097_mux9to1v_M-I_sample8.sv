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

wire [15:0] mux_level1_0, mux_level1_1, mux_level1_2, mux_level1_3, mux_level1_4;
wire [15:0] mux_level2_0, mux_level2_1, mux_level2_2;
wire [15:0] mux_level3_0, mux_level3_1;
wire [15:0] mux_level4;
wire sel_bit0 = sel[0];
wire sel_bit1 = sel[1];
wire sel_bit2 = sel[2];
wire sel_bit3 = sel[3];

// Level 1: 2-to-1 muxes, 5 muxes cover 9 inputs + 1 dummy
assign mux_level1_0 = sel_bit0 ? b : a; // sel[0], inputs a,b (0,1)
assign mux_level1_1 = sel_bit0 ? d : c; // inputs c,d (2,3)
assign mux_level1_2 = sel_bit0 ? f : e; // inputs e,f (4,5)
assign mux_level1_3 = sel_bit0 ? h : g; // inputs g,h (6,7)
assign mux_level1_4 = i;                 // input i (8)

// Level 2: mux pairs and one pass-through
assign mux_level2_0 = sel_bit1 ? mux_level1_1 : mux_level1_0; // selects between (a,b,c,d)
assign mux_level2_1 = sel_bit1 ? mux_level1_3 : mux_level1_2; // selects between (e,f,g,h)
assign mux_level2_2 = mux_level1_4;                           // i alone

// Level 3: mux between mux_level2_1 and mux_level2_0; mux_level2_2 passed through
assign mux_level3_0 = sel_bit2 ? mux_level2_1 : mux_level2_0; // selects among inputs 0-7
assign mux_level3_1 = mux_level2_2;                           // input 8

// Level 4: final mux selects between mux_level3_0 and mux_level3_1 or outputs 16'hFFFF for sel >= 9
assign mux_level4 = (sel_bit3 == 1'b0) ? mux_level3_0 :
                    (sel == 4'd8) ? mux_level3_1 :
                    16'hFFFF;

assign out = mux_level4;

endmodule