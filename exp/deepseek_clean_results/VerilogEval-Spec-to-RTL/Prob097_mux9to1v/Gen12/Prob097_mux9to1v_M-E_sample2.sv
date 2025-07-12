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

// Priority encoded enable signals
wire en_a = (sel == 4'd0);
wire en_b = (sel == 4'd1);
wire en_c = (sel == 4'd2);
wire en_d = (sel == 4'd3);
wire en_e = (sel == 4'd4);
wire en_f = (sel == 4'd5);
wire en_g = (sel == 4'd6);
wire en_h = (sel == 4'd7);
wire en_i = (sel == 4'd8);

// Detect invalid selection (sel >= 9)
wire invalid_sel = sel[3];  // MSB set when sel >= 8

// Create masked versions of each input
wire [15:0] masked_a = a & {16{en_a}};
wire [15:0] masked_b = b & {16{en_b}};
wire [15:0] masked_c = c & {16{en_c}};
wire [15:0] masked_d = d & {16{en_d}};
wire [15:0] masked_e = e & {16{en_e}};
wire [15:0] masked_f = f & {16{en_f}};
wire [15:0] masked_g = g & {16{en_g}};
wire [15:0] masked_h = h & {16{en_h}};
wire [15:0] masked_i = i & {16{en_i}};

// Combine all masked inputs (only one will be non-zero)
wire [15:0] selected = masked_a | masked_b | masked_c | masked_d |
                      masked_e | masked_f | masked_g | masked_h |
                      masked_i;

// Output selection - use selected value or all 1's for invalid
assign out = invalid_sel ? 16'hFFFF : selected;

endmodule