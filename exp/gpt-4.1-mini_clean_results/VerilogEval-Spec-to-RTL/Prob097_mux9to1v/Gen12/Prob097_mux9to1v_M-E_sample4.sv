module TopModule(
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

    // Level 1 muxes: each 3-to-1 mux uses sel[1:0]
    wire [15:0] mux0, mux1, mux2;

    // 3-to-1 mux: selects a,b,c
    assign mux0 = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b :
                  (sel[1:0] == 2'd2) ? c : 16'hFFFF;

    // 3-to-1 mux: selects d,e,f
    assign mux1 = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e :
                  (sel[1:0] == 2'd2) ? f : 16'hFFFF;

    // 3-to-1 mux: selects g,h,i
    assign mux2 = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h :
                  (sel[1:0] == 2'd2) ? i : 16'hFFFF;

    // Level 2 mux: selects among mux0,mux1,mux2 based on sel[3:2]
    wire [15:0] level2_out;
    assign level2_out = (sel[3:2] == 2'd0) ? mux0 :
                        (sel[3:2] == 2'd1) ? mux1 :
                        (sel[3:2] == 2'd2) ? mux2 : 16'hFFFF;

    // Final output: if sel > 8 (i.e. 9 to 15), output 16'hFFFF
    assign out = (sel <= 4'd8) ? level2_out : 16'hFFFF;

endmodule