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

    // First layer: mux pairs (4 bits selector used progressively)
    wire [15:0] mux_level1_0 = (sel[0] == 1'b0) ? a : b; // sel=0 or 1
    wire [15:0] mux_level1_1 = (sel[0] == 1'b0) ? c : d; // sel=2 or 3
    wire [15:0] mux_level1_2 = (sel[0] == 1'b0) ? e : f; // sel=4 or 5
    wire [15:0] mux_level1_3 = (sel[0] == 1'b0) ? g : h; // sel=6 or 7

    // Second layer: mux pairs using sel[1]
    wire [15:0] mux_level2_0 = (sel[1] == 1'b0) ? mux_level1_0 : mux_level1_1; // sel=0-3
    wire [15:0] mux_level2_1 = (sel[1] == 1'b0) ? mux_level1_2 : mux_level1_3; // sel=4-7

    // Third layer: mux pairs using sel[2]
    wire [15:0] mux_level3_0 = (sel[2] == 1'b0) ? mux_level2_0 : mux_level2_1; // sel=0-7

    // Fourth layer: sel=8 chooses i, else previous result; using sel[3]
    // For sel=8, sel[3:0] = 4'b1000
    // Detect sel==8 precisely:
    wire sel_is_8 = (sel == 4'd8);

    // If sel is 8, select i; else select mux_level3_0
    wire [15:0] mux_level3_1 = (sel_is_8) ? i : mux_level3_0;

    // Output logic: for sel <=8 select mux_level3_1, else all ones
    wire sel_in_range = (sel <= 4'd8);
    assign out = sel_in_range ? mux_level3_1 : 16'hFFFF;

endmodule