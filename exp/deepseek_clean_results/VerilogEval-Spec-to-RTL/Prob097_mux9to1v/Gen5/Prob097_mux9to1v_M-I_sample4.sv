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

// First level muxes (4-to-1)
wire [15:0] mux1_out, mux2_out, mux3_out;

assign mux1_out = (sel[1:0] == 2'b00) ? a :
                  (sel[1:0] == 2'b01) ? b :
                  (sel[1:0] == 2'b10) ? c : d;

assign mux2_out = (sel[1:0] == 2'b00) ? e :
                  (sel[1:0] == 2'b01) ? f :
                  (sel[1:0] == 2'b10) ? g : h;

assign mux3_out = i; // Only one input for this path

// Second level mux (2-to-1)
wire [15:0] stage2_out = sel[2] ? mux3_out : 
                        (sel[1:0] == 2'b11) ? mux2_out : mux1_out;

// Final output with default handling
assign out = (sel[3] | (sel[2:0] > 3'd8)) ? 16'hFFFF : stage2_out;

endmodule