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

// One-hot decoder
wire [15:0] sel_onehot;
assign sel_onehot = (sel < 9) ? (16'b1 << sel) : 16'b0;

// Bitwise AND-OR mux structure
assign out = (sel_onehot[0] ? a : 16'b0) |
             (sel_onehot[1] ? b : 16'b0) |
             (sel_onehot[2] ? c : 16'b0) |
             (sel_onehot[3] ? d : 16'b0) |
             (sel_onehot[4] ? e : 16'b0) |
             (sel_onehot[5] ? f : 16'b0) |
             (sel_onehot[6] ? g : 16'b0) |
             (sel_onehot[7] ? h : 16'b0) |
             (sel_onehot[8] ? i : 16'b0) |
             ((|sel_onehot[15:9]) ? 16'hFFFF : 16'b0);

endmodule