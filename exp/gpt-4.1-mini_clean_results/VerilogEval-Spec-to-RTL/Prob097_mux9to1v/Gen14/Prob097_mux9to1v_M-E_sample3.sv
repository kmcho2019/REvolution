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

    // Intermediate 3-to-1 mux outputs
    wire [15:0] group0; // for sel[1:0] = 0..2: selects a, b, c
    wire [15:0] group1; // for sel[1:0] = 0..2: selects d, e, f
    wire [15:0] group2; // for sel[1:0] = 0..2: selects g, h, i

    // Group 0 mux: a,b,c selected by sel[1:0]
    assign group0 = (sel[1:0] == 2'd0) ? a :
                    (sel[1:0] == 2'd1) ? b :
                    (sel[1:0] == 2'd2) ? c : 16'hFFFF;

    // Group 1 mux: d,e,f selected by sel[1:0]
    assign group1 = (sel[1:0] == 2'd0) ? d :
                    (sel[1:0] == 2'd1) ? e :
                    (sel[1:0] == 2'd2) ? f : 16'hFFFF;

    // Group 2 mux: g,h,i selected by sel[1:0]
    assign group2 = (sel[1:0] == 2'd0) ? g :
                    (sel[1:0] == 2'd1) ? h :
                    (sel[1:0] == 2'd2) ? i : 16'hFFFF;

    // Top-level mux selects among group0, group1, group2 or 16'hFFFF for invalid sel
    // Valid sel range: 0 to 8, corresponding to:
    // sel[3:2] = 0 (group0), 1 (group1), 2 (group2)
    // sel[1:0] = 0..2 selects the element in each group
    assign out = (sel[3:2] == 2'd0 && sel[1:0] <= 2'd2) ? group0 :
                 (sel[3:2] == 2'd1 && sel[1:0] <= 2'd2) ? group1 :
                 (sel[3:2] == 2'd2 && sel[1:0] <= 2'd2) ? group2 :
                 16'hFFFF;

endmodule