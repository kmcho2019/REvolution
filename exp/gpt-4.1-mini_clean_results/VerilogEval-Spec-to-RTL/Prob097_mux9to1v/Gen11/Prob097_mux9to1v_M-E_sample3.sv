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

    // Generate individual select signals for each valid input (0-8)
    wire sel_0 = (sel == 4'd0);
    wire sel_1 = (sel == 4'd1);
    wire sel_2 = (sel == 4'd2);
    wire sel_3 = (sel == 4'd3);
    wire sel_4 = (sel == 4'd4);
    wire sel_5 = (sel == 4'd5);
    wire sel_6 = (sel == 4'd6);
    wire sel_7 = (sel == 4'd7);
    wire sel_8 = (sel == 4'd8);

    // For sel values outside 0-8, output all ones
    wire sel_invalid = (sel > 4'd8);

    // Mask and combine inputs
    wire [15:0] masked_a = {16{sel_0}} & a;
    wire [15:0] masked_b = {16{sel_1}} & b;
    wire [15:0] masked_c = {16{sel_2}} & c;
    wire [15:0] masked_d = {16{sel_3}} & d;
    wire [15:0] masked_e = {16{sel_4}} & e;
    wire [15:0] masked_f = {16{sel_5}} & f;
    wire [15:0] masked_g = {16{sel_6}} & g;
    wire [15:0] masked_h = {16{sel_7}} & h;
    wire [15:0] masked_i = {16{sel_8}} & i;

    // Combine all masked inputs
    wire [15:0] combined = masked_a | masked_b | masked_c | masked_d | masked_e |
                          masked_f | masked_g | masked_h | masked_i;

    // Final output: if sel is invalid output all ones, else combined input
    assign out = sel_invalid ? 16'hFFFF : combined;

endmodule