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

wire [15:0] mux0, mux1, mux2, mux3, mux4;
wire [15:0] mux5, mux6, mux7, mux8;
wire select_unused;

// Level 1: pairwise 2-to-1 muxes for inputs 0 to 7
assign mux0 = (sel[0] == 1'b0) ? a : b; // sel[0] picks a or b
assign mux1 = (sel[0] == 1'b0) ? c : d; // sel[0] picks c or d
assign mux2 = (sel[0] == 1'b0) ? e : f; // sel[0] picks e or f
assign mux3 = (sel[0] == 1'b0) ? g : h; // sel[0] picks g or h

// i has no pair, so mux4 = i
assign mux4 = i;

// Level 2: mux1 with sel[1]
assign mux5 = (sel[1] == 1'b0) ? mux0 : mux1; // chooses between mux0 and mux1
assign mux6 = (sel[1] == 1'b0) ? mux2 : mux3; // chooses between mux2 and mux3

// Level 3: mux2 with sel[2]
assign mux7 = (sel[2] == 1'b0) ? mux5 : mux6;

// Level 4: select between mux7 and mux4 using sel[3]
assign select_unused = (sel >= 4'd9);
assign out = select_unused ? 16'hFFFF :
             (sel[3] == 1'b0) ? mux7 : mux4;

endmodule