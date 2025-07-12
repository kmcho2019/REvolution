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

    wire [15:0] mux0_out; // selects among a,b,c based on sel[1:0]
    wire [15:0] mux1_out; // selects among d,e,f based on sel[1:0]
    wire [15:0] mux2_out; // selects among g,h,i based on sel[1:0]

    // 3-to-1 muxes for lower level selection
    assign mux0_out = (sel[1:0] == 2'd0) ? a :
                      (sel[1:0] == 2'd1) ? b :
                                           c;

    assign mux1_out = (sel[1:0] == 2'd0) ? d :
                      (sel[1:0] == 2'd1) ? e :
                                           f;

    assign mux2_out = (sel[1:0] == 2'd0) ? g :
                      (sel[1:0] == 2'd1) ? h :
                                           i;

    // Final 3-to-1 mux using sel[3:2]; if sel>=9 output all ones
    assign out = (sel[3:2] == 2'd0) ? mux0_out :
                 (sel[3:2] == 2'd1) ? mux1_out :
                 (sel[3:2] == 2'd2) ? mux2_out :
                                      16'hFFFF;

endmodule