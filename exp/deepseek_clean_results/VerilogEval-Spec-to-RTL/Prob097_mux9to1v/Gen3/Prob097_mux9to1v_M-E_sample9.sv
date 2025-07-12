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

// Generate selection masks
wire [15:0] mask_a = {16{sel == 4'd0}};
wire [15:0] mask_b = {16{sel == 4'd1}};
wire [15:0] mask_c = {16{sel == 4'd2}};
wire [15:0] mask_d = {16{sel == 4'd3}};
wire [15:0] mask_e = {16{sel == 4'd4}};
wire [15:0] mask_f = {16{sel == 4'd5}};
wire [15:0] mask_g = {16{sel == 4'd6}};
wire [15:0] mask_h = {16{sel == 4'd7}};
wire [15:0] mask_i = {16{sel == 4'd8}};
wire [15:0] mask_default = {16{sel >= 4'd9}};

// Apply masks and combine results
assign out = (a & mask_a) | (b & mask_b) | (c & mask_c) |
             (d & mask_d) | (e & mask_e) | (f & mask_f) |
             (g & mask_g) | (h & mask_h) | (i & mask_i) |
             (16'hFFFF & mask_default);

endmodule