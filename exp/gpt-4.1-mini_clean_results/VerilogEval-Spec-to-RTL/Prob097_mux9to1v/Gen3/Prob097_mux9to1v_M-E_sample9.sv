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

wire [15:0] mux0_2; // select from a, b, c
wire [15:0] mux3_5; // select from d, e, f
wire [15:0] mux6_8; // select from g, h, i

// 3-to-1 muxes selecting inputs based on sel[1:0]
assign mux0_2 = (sel[1:0] == 2'd0) ? a :
                (sel[1:0] == 2'd1) ? b :
                c;

assign mux3_5 = (sel[1:0] == 2'd0) ? d :
                (sel[1:0] == 2'd1) ? e :
                f;

assign mux6_8 = (sel[1:0] == 2'd0) ? g :
                (sel[1:0] == 2'd1) ? h :
                i;

// top-level 3-to-1 mux selecting among the three groups using sel[3:2]
wire [15:0] mux_out;
assign mux_out = (sel[3:2] == 2'd0) ? mux0_2 :
                 (sel[3:2] == 2'd1) ? mux3_5 :
                 (sel[3:2] == 2'd2) ? mux6_8 :
                 16'hFFFF; // covers sel==12..15 (only sel==9..11 needed but safe)

// If sel >= 9, output 16'hFFFF, else output mux_out
assign out = (sel >= 4'd9) ? 16'hFFFF : mux_out;

endmodule