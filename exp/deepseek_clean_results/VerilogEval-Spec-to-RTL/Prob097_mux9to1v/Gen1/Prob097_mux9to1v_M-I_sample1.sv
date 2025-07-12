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

wire [15:0] mux_level1 [2:0];
wire [15:0] mux_level2;

// First level muxes (3:1 each)
assign mux_level1[0] = (sel[1:0] == 2'd0) ? a :
                      (sel[1:0] == 2'd1) ? b : c;

assign mux_level1[1] = (sel[1:0] == 2'd0) ? d :
                      (sel[1:0] == 2'd1) ? e : f;

assign mux_level1[2] = (sel[1:0] == 2'd0) ? g :
                      (sel[1:0] == 2'd1) ? h : i;

// Second level mux (3:1)
assign mux_level2 = (sel[3:2] == 2'd0) ? mux_level1[0] :
                   (sel[3:2] == 2'd1) ? mux_level1[1] :
                   (sel[3:2] == 2'd2) ? mux_level1[2] : 16'hFFFF;

// Final output - handle sel=9-15 cases
assign out = (sel > 4'd8) ? 16'hFFFF : mux_level2;

endmodule