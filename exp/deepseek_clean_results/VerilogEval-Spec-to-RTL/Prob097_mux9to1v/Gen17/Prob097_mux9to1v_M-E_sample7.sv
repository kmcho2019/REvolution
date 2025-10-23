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

// First level muxes (3 groups of 3 inputs)
wire [15:0] mux1_out, mux2_out, mux3_out;

// Second level mux (selects between first level mux outputs)
wire [15:0] final_mux_out;

// Selection validity
wire invalid_sel = (sel >= 4'd9);

// First level muxes
assign mux1_out = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b :
                  (sel[1:0] == 2'd2) ? c : 16'hFFFF;

assign mux2_out = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e :
                  (sel[1:0] == 2'd2) ? f : 16'hFFFF;

assign mux3_out = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h :
                  (sel[1:0] == 2'd2) ? i : 16'hFFFF;

// Second level mux
assign final_mux_out = (sel[3:2] == 2'd0) ? mux1_out :
                       (sel[3:2] == 2'd1) ? mux2_out :
                       (sel[3:2] == 2'd2) ? mux3_out : 16'hFFFF;

// Output with invalid selection handling
assign out = final_mux_out | {16{invalid_sel}};

endmodule