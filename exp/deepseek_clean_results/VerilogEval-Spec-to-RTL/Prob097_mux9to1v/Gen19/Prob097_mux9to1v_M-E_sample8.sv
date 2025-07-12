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

// Early detection of invalid selection (sel >= 9)
wire valid_sel = ~sel[3]; // MSB=1 when sel >=8 (but we need >=9)
wire really_valid = valid_sel & ~(&sel[2:0]); // Check if sel < 9

// First level muxes (3 groups of 3 inputs)
wire [15:0] mux1_out, mux2_out, mux3_out;

assign mux1_out = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b :
                  (sel[1:0] == 2'd2) ? c : 16'hFFFF;

assign mux2_out = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e :
                  (sel[1:0] == 2'd2) ? f : 16'hFFFF;

assign mux3_out = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h :
                  (sel[1:0] == 2'd2) ? i : 16'hFFFF;

// Second level mux (select between the first level outputs)
wire [15:0] mux_final = (sel[3:2] == 2'b00) ? mux1_out :
                        (sel[3:2] == 2'b01) ? mux2_out :
                        (sel[3:2] == 2'b10) ? mux3_out : 16'hFFFF;

// Final output gated by validity
assign out = really_valid ? mux_final : 16'hFFFF;

endmodule