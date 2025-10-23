module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Level 1: Split into two 4-bit halves
wire left_half_active = |in[3:0];
wire [1:0] level1_sel = left_half_active ? 2'b00 : 2'b01;

// Level 2: Split each half into two 2-bit quarters
wire [1:0] level2_in = level1_sel[1] ? in[7:4] : in[3:0];
wire left_quarter_active = |level2_in[1:0];
wire [1:0] level2_sel = {level1_sel[1], left_quarter_active ? 1'b0 : 1'b1};

// Level 3: Split each quarter into two 1-bit eighths
wire [1:0] level3_in = level2_sel[0] ? 
                        (level2_sel[1] ? in[7:6] : in[3:2]) :
                        (level2_sel[1] ? in[5:4] : in[1:0]);
wire bit_sel = ~level3_in[0];

// Combine all level selections
assign pos = {level2_sel[1], level2_sel[0], bit_sel} & {3{|in}};

endmodule