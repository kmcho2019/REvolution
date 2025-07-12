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
wire [15:0] final_mux_out;
wire default_case;

// First level muxes (4:1 each)
assign mux1_out = (sel[1:0] == 2'b00) ? a :
                  (sel[1:0] == 2'b01) ? b :
                  (sel[1:0] == 2'b10) ? c : d;

assign mux2_out = (sel[1:0] == 2'b00) ? e :
                  (sel[1:0] == 2'b01) ? f :
                  (sel[1:0] == 2'b10) ? g : h;

// Special handling for i and default cases
assign mux3_out = (sel[0]) ? 16'hFFFF : i;  // sel[0] here helps cover cases 9-15

// Second level mux (3:1)
assign final_mux_out = (sel[3:2] == 2'b00) ? mux1_out :
                       (sel[3:2] == 2'b01) ? mux2_out : mux3_out;

// Force default case when sel is 9-15
assign default_case = sel[3] & sel[2];  // True when sel is 12-15
assign out = (default_case) ? 16'hFFFF : final_mux_out;

endmodule