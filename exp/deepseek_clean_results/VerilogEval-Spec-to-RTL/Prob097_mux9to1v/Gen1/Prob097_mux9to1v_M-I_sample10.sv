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
wire        default_case;

// First level: 3 groups of 3-to-1 muxes
assign mux_level1[0] = (sel[1:0] == 2'd0) ? a :
                       (sel[1:0] == 2'd1) ? b :
                       c;

assign mux_level1[1] = (sel[1:0] == 2'd0) ? d :
                       (sel[1:0] == 2'd1) ? e :
                       f;

assign mux_level1[2] = (sel[1:0] == 2'd0) ? g :
                       (sel[1:0] == 2'd1) ? h :
                       i;

// Second level: 3-to-1 mux
assign mux_level2 = (sel[3:2] == 2'd0) ? mux_level1[0] :
                    (sel[3:2] == 2'd1) ? mux_level1[1] :
                    mux_level1[2];

// Default case detection (sel >= 9)
assign default_case = sel[3] & (sel[2] | sel[1]);

// Final output selection
assign out = default_case ? 16'hFFFF : mux_level2;

endmodule