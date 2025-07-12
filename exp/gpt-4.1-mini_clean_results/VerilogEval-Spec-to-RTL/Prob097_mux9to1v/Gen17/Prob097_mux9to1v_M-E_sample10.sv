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

wire [143:0] all_inputs; // 9 * 16 = 144 bits

assign all_inputs = {i, h, g, f, e, d, c, b, a}; // Concatenate inputs from MSB (i) to LSB (a)

wire [7:0] shift_amount = sel * 16;
wire [15:0] selected_segment = (shift_amount < 144) ? (all_inputs >> shift_amount)[15:0] : 16'hFFFF;

assign out = (sel <= 4'd8) ? selected_segment : 16'hFFFF;

endmodule