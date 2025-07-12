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

// First level muxes (4x 2-to-1)
wire [15:0] mux1_out = sel[0] ? b : a;
wire [15:0] mux2_out = sel[0] ? d : c;
wire [15:0] mux3_out = sel[0] ? f : e;
wire [15:0] mux4_out = sel[0] ? h : g;

// Second level muxes (2x 2-to-1)
wire [15:0] mux5_out = sel[1] ? mux2_out : mux1_out;
wire [15:0] mux6_out = sel[1] ? mux4_out : mux3_out;

// Third level mux (1x 2-to-1)
wire [15:0] mux7_out = sel[2] ? mux6_out : mux5_out;

// Fourth level mux (select between first 8 inputs and input i)
wire [15:0] mux8_out = sel[3] ? i : mux7_out;

// Final output - use MSB to select between valid cases and default
assign out = (sel[3] && |sel[2:0]) ? 16'hFFFF : mux8_out;

endmodule