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

// Intermediate mux outputs
wire [15:0] mux1_out, mux2_out, mux3_out;
wire [15:0] final_mux_out;
wire invalid_sel;

// First stage: Three 3:1 muxes
assign mux1_out = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b :
                  c;

assign mux2_out = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e :
                  f;

assign mux3_out = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h :
                  i;

// Second stage: Final 3:1 mux
assign final_mux_out = (sel[3:2] == 2'd0) ? mux1_out :
                       (sel[3:2] == 2'd1) ? mux2_out :
                       mux3_out;

// Detect invalid selection (sel > 8)
assign invalid_sel = |sel[3:2] & sel[1];  // sel >= 9

// Output with default handling
assign out = invalid_sel ? 16'hFFFF : final_mux_out;

endmodule