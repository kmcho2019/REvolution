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

// Hierarchical 3:1 mux implementation
wire [15:0] mux_stage1 [2:0];
wire [15:0] mux_stage2 [2:0];

// First stage: 3 groups of 3 inputs
assign mux_stage1[0] = (sel[1:0] == 2'b00) ? a :
                       (sel[1:0] == 2'b01) ? b : c;
assign mux_stage1[1] = (sel[1:0] == 2'b00) ? d :
                       (sel[1:0] == 2'b01) ? e : f;
assign mux_stage1[2] = (sel[1:0] == 2'b00) ? g :
                       (sel[1:0] == 2'b01) ? h : i;

// Second stage: mux between the first stage outputs
assign mux_stage2[0] = (sel[3:2] == 2'b00) ? mux_stage1[0] :
                       (sel[3:2] == 2'b01) ? mux_stage1[1] : mux_stage1[2];

// Final output with default handling
assign out = (sel < 4'd9) ? mux_stage2[0] : 16'hFFFF;

endmodule