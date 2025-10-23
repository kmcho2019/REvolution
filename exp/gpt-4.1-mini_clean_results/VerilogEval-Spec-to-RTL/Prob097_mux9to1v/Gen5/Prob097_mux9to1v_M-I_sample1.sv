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

    wire [15:0] mux_lvl1 [2:0];
    wire invalid_sel = (sel >= 4'd9);

    // First level: 3 groups of 3 inputs each
    assign mux_lvl1[0] = (sel[1:0] == 2'd0) ? a :
                         (sel[1:0] == 2'd1) ? b :
                         c;
    assign mux_lvl1[1] = (sel[1:0] == 2'd0) ? d :
                         (sel[1:0] == 2'd1) ? e :
                         f;
    assign mux_lvl1[2] = (sel[1:0] == 2'd0) ? g :
                         (sel[1:0] == 2'd1) ? h :
                         i;

    // Second level: select one from the first level based on sel[3:2]
    wire [1:0] group_sel = sel[3:2];
    wire [15:0] mux_lvl2;
    assign mux_lvl2 = (group_sel == 2'd0) ? mux_lvl1[0] :
                      (group_sel == 2'd1) ? mux_lvl1[1] :
                      mux_lvl1[2];

    // Output all ones for invalid sel, else mux result
    assign out = invalid_sel ? 16'hFFFF : mux_lvl2;

endmodule