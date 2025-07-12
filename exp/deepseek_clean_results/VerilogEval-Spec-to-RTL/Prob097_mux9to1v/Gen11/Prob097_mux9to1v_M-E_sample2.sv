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
wire [15:0] mask_default = {16{sel > 4'd8}};

// Apply masks to inputs
wire [15:0] masked_a = a & mask_a;
wire [15:0] masked_b = b & mask_b;
wire [15:0] masked_c = c & mask_c;
wire [15:0] masked_d = d & mask_d;
wire [15:0] masked_e = e & mask_e;
wire [15:0] masked_f = f & mask_f;
wire [15:0] masked_g = g & mask_g;
wire [15:0] masked_h = h & mask_h;
wire [15:0] masked_i = i & mask_i;
wire [15:0] masked_default = mask_default;

// Combine all masked inputs
assign out = masked_a | masked_b | masked_c | masked_d |
             masked_e | masked_f | masked_g | masked_h |
             masked_i | masked_default;

endmodule