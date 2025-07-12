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

wire [15:0] mux1_out, mux2_out, mux3_out;
wire [15:0] stage1_out;

// First level muxes (3-to-1 each)
assign mux1_out = (sel[1:0] == 2'b00) ? a :
                  (sel[1:0] == 2'b01) ? b :
                  c;

assign mux2_out = (sel[1:0] == 2'b00) ? d :
                  (sel[1:0] == 2'b01) ? e :
                  f;

assign mux3_out = (sel[1:0] == 2'b00) ? g :
                  (sel[1:0] == 2'b01) ? h :
                  i;

// Second level mux (3-to-1)
assign stage1_out = (sel[2] == 1'b0) ? 
                   ((sel[1:0] == 2'b11) ? 16'hFFFF : mux1_out) :
                   ((sel[1:0] == 2'b11) ? 16'hFFFF : mux2_out);

// Final selection and default handling
assign out = sel[3] ? 16'hFFFF : 
             (sel[2:0] == 3'b110) ? mux3_out :
             (sel[2:0] == 3'b111) ? 16'hFFFF :
             stage1_out;

endmodule