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

    wire [15:0] mux0;
    wire [15:0] mux1;
    wire [15:0] mux2;

    // 3-to-1 mux for inputs a, b, c based on sel[1:0]
    assign mux0 = (sel[1:0] == 2'd0) ? a :
                  (sel[1:0] == 2'd1) ? b :
                  (sel[1:0] == 2'd2) ? c : 16'hXXXX;

    // 3-to-1 mux for inputs d, e, f based on sel[1:0]
    assign mux1 = (sel[1:0] == 2'd0) ? d :
                  (sel[1:0] == 2'd1) ? e :
                  (sel[1:0] == 2'd2) ? f : 16'hXXXX;

    // 3-to-1 mux for inputs g, h, i based on sel[1:0]
    assign mux2 = (sel[1:0] == 2'd0) ? g :
                  (sel[1:0] == 2'd1) ? h :
                  (sel[1:0] == 2'd2) ? i : 16'hXXXX;

    // Final mux selects among mux0, mux1, mux2 based on sel[3:2]
    // Only sel=0 to 8 are valid
    // Map sel values: 
    // 0-2 -> mux0
    // 3-5 -> mux1
    // 6-8 -> mux2
    // Otherwise output 16'hFFFF

    wire valid_sel = (sel < 4'd9);

    wire [15:0] level2_mux = (sel[3:2] == 2'd0) ? mux0 :
                             (sel[3:2] == 2'd1) ? mux1 :
                             (sel[3:2] == 2'd2) ? mux2 : 16'hXXXX;

    assign out = valid_sel ? level2_mux : 16'hFFFF;

endmodule