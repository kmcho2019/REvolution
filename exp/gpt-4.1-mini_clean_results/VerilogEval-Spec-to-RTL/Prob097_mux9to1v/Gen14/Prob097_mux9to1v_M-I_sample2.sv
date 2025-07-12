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

    // First stage: mux pairs using sel[0]
    wire [15:0] stage1_0 = (sel[0] == 1'b0) ? a : b; // selects a or b
    wire [15:0] stage1_1 = (sel[0] == 1'b0) ? c : d; // selects c or d
    wire [15:0] stage1_2 = (sel[0] == 1'b0) ? e : f; // selects e or f
    wire [15:0] stage1_3 = (sel[0] == 1'b0) ? g : h; // selects g or h
    // input i has no pair, hold as is for now
    wire [15:0] stage1_4 = i;

    // Second stage: mux pairs using sel[1]
    wire [15:0] stage2_0 = (sel[1] == 1'b0) ? stage1_0 : stage1_1; // selects from (a/b) or (c/d)
    wire [15:0] stage2_1 = (sel[1] == 1'b0) ? stage1_2 : stage1_3; // selects from (e/f) or (g/h)
    // stage1_4 (i) has no pair, pass through or pair with a constant
    wire [15:0] stage2_2 = stage1_4;

    // Third stage: mux pairs using sel[2]
    wire [15:0] stage3_0 = (sel[2] == 1'b0) ? stage2_0 : stage2_1; // selects from previous two pairs
    wire [15:0] stage3_1 = stage2_2; // i stays the same

    // Fourth stage: mux final using sel[3]
    wire [15:0] stage4_0 = (sel[3] == 1'b0) ? stage3_0 : stage3_1;

    // Output: if sel > 8, output 16'hFFFF, else output stage4_0
    assign out = (sel <= 4'd8) ? stage4_0 : 16'hFFFF;

endmodule