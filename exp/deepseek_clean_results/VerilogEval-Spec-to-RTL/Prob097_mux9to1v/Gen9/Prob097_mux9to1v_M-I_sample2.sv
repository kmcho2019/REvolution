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
    output reg [15:0] out
);

// Internal signals for hierarchical muxing
wire [15:0] stage1_out0, stage1_out1, stage1_out2;
wire [15:0] stage2_out0, stage2_out1;

// Early detection of default case
wire is_default = (sel > 4'd8);

// First stage muxes (3:1 each)
assign stage1_out0 = (sel[1:0] == 2'd0) ? a : 
                    (sel[1:0] == 2'd1) ? b : c;
assign stage1_out1 = (sel[1:0] == 2'd0) ? d : 
                    (sel[1:0] == 2'd1) ? e : f;
assign stage1_out2 = (sel[1:0] == 2'd0) ? g : 
                    (sel[1:0] == 2'd1) ? h : i;

// Second stage mux (3:1)
assign stage2_out0 = (sel[3:2] == 2'd0) ? stage1_out0 :
                    (sel[3:2] == 2'd1) ? stage1_out1 : stage1_out2;

// Output selection
always @(*) begin
    if (is_default)
        out = 16'hFFFF;  // sel 9-15
    else
        out = stage2_out0;
end

endmodule