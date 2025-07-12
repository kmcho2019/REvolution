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

    wire [15:0] group0, group1, group2;
    wire sel_valid;

    // First level: 3-to-1 mux for each group, select input within group by sel[1:0]
    // group0: a,b,c
    assign group0 = (sel[1:0] == 2'd0) ? a :
                    (sel[1:0] == 2'd1) ? b :
                    (sel[1:0] == 2'd2) ? c : 16'hFFFF;  // out-of-group default (should not occur)

    // group1: d,e,f
    assign group1 = (sel[1:0] == 2'd0) ? d :
                    (sel[1:0] == 2'd1) ? e :
                    (sel[1:0] == 2'd2) ? f : 16'hFFFF;

    // group2: g,h,i
    assign group2 = (sel[1:0] == 2'd0) ? g :
                    (sel[1:0] == 2'd1) ? h :
                    (sel[1:0] == 2'd2) ? i : 16'hFFFF;

    // Check if sel is in the valid range 0 to 8 (0b0000 to 0b1000)
    assign sel_valid = (sel <= 4'd8);

    // Second level: 3-to-1 mux selects one of the groups by sel[3:2]
    // sel[3:2] == 0 -> group0, ==1 -> group1, ==2 -> group2, else invalid
    wire [15:0] second_level_mux;
    assign second_level_mux = (sel[3:2] == 2'd0) ? group0 :
                              (sel[3:2] == 2'd1) ? group1 :
                              (sel[3:2] == 2'd2) ? group2 :
                              16'hFFFF;

    // Final output: if sel valid output selected data, else 16'hFFFF
    assign out = sel_valid ? second_level_mux : 16'hFFFF;

endmodule