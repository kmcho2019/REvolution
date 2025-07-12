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

// Stage 1: First level of 2-to-1 muxes (8 inputs -> 4 outputs)
wire [15:0] stage1 [0:3];
assign stage1[0] = sel[0] ? b : a;
assign stage1[1] = sel[0] ? d : c;
assign stage1[2] = sel[0] ? f : e;
assign stage1[3] = sel[0] ? h : g;

// Stage 2: Second level of 2-to-1 muxes (4 inputs -> 2 outputs)
wire [15:0] stage2 [0:1];
assign stage2[0] = sel[1] ? stage1[1] : stage1[0];
assign stage2[1] = sel[1] ? stage1[3] : stage1[2];

// Stage 3: Third level of 2-to-1 muxes (2 inputs + i -> 1 output)
wire [15:0] stage3;
assign stage3 = sel[2] ? stage2[1] : stage2[0];

// Final output with default case handling
assign out = (sel[3] | (|sel[2:0] & (sel >= 9))) ? 16'hFFFF : 
             (sel[2:0] == 3'b100) ? i : stage3;

endmodule