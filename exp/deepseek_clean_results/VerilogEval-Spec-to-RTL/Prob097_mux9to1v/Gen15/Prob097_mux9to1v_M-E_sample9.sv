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

// First level muxes - group inputs into sets of 3
wire [15:0] mux1_out, mux2_out, mux3_out;

assign mux1_out = (sel[1:0] == 2'b00) ? a :
                  (sel[1:0] == 2'b01) ? b :
                  (sel[1:0] == 2'b10) ? c : 16'hFFFF;

assign mux2_out = (sel[1:0] == 2'b00) ? d :
                  (sel[1:0] == 2'b01) ? e :
                  (sel[1:0] == 2'b10) ? f : 16'hFFFF;

assign mux3_out = (sel[1:0] == 2'b00) ? g :
                  (sel[1:0] == 2'b01) ? h :
                  (sel[1:0] == 2'b10) ? i : 16'hFFFF;

// Second level mux - select between the groups
wire [15:0] final_mux_out;
assign final_mux_out = (sel[3:2] == 2'b00) ? mux1_out :
                       (sel[3:2] == 2'b01) ? mux2_out :
                       (sel[3:2] == 2'b10) ? mux3_out : 16'hFFFF;

// Priority encoder for invalid cases
assign out = (sel > 4'd8) ? 16'hFFFF : final_mux_out;

endmodule