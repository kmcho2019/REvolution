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

wire [15:0] stage1 [0:2];
wire [15:0] stage2 [0:2];
wire [15:0] final_out;
wire valid_sel;

// Input gating and first stage mux (3x 3-to-1)
assign stage1[0] = (sel[1:0] == 2'd0) ? a : 
                   (sel[1:0] == 2'd1) ? b : 
                   (sel[1:0] == 2'd2) ? c : 16'hFFFF;

assign stage1[1] = (sel[1:0] == 2'd0) ? d : 
                   (sel[1:0] == 2'd1) ? e : 
                   (sel[1:0] == 2'd2) ? f : 16'hFFFF;

assign stage1[2] = (sel[1:0] == 2'd0) ? g : 
                   (sel[1:0] == 2'd1) ? h : 
                   (sel[1:0] == 2'd2) ? i : 16'hFFFF;

// Second stage mux (3-to-1)
assign stage2[0] = (sel[3:2] == 2'd0) ? stage1[0] : 
                   (sel[3:2] == 2'd1) ? stage1[1] : 
                   (sel[3:2] == 2'd2) ? stage1[2] : 16'hFFFF;

// Valid selection check (sel < 9)
assign valid_sel = ~|sel[3:1] |  // sel 0-1
                  (&sel[3:1] ^ sel[0]); // sel 2-8

// Final output with optimized default case
assign out = valid_sel ? stage2[0] : {16{1'b1}};

endmodule