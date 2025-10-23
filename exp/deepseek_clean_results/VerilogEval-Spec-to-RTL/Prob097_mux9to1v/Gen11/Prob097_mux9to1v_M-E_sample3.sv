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

// First level muxes (3 groups of 3:1 muxes)
wire [15:0] mux1_out, mux2_out, mux3_out;

// Group 1: a, b, c
assign mux1_out = (sel[1:0] == 2'b00) ? a :
                  (sel[1:0] == 2'b01) ? b :
                  (sel[1:0] == 2'b10) ? c : 16'hFFFF;

// Group 2: d, e, f
assign mux2_out = (sel[1:0] == 2'b00) ? d :
                  (sel[1:0] == 2'b01) ? e :
                  (sel[1:0] == 2'b10) ? f : 16'hFFFF;

// Group 3: g, h, i
assign mux3_out = (sel[1:0] == 2'b00) ? g :
                  (sel[1:0] == 2'b01) ? h :
                  (sel[1:0] == 2'b10) ? i : 16'hFFFF;

// Second level mux (3:1)
wire [15:0] final_mux;
assign final_mux = (sel[3:2] == 2'b00) ? mux1_out :
                  (sel[3:2] == 2'b01) ? mux2_out :
                  (sel[3:2] == 2'b10) ? mux3_out : 16'hFFFF;

// Output logic with power gating for invalid cases
wire valid = (sel < 4'd9);
assign out = valid ? final_mux : 16'hFFFF;

endmodule