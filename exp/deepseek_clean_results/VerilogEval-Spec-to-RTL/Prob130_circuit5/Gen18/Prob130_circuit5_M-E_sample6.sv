module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Selection masks for each case
wire sel_b = (c == 4'd0);
wire sel_e = (c == 4'd1);
wire sel_a = (c == 4'd2);
wire sel_d = (c == 4'd3);

// Mask each input with its selection bit
wire [3:0] masked_b = b & {4{sel_b}};
wire [3:0] masked_e = e & {4{sel_e}};
wire [3:0] masked_a = a & {4{sel_a}};
wire [3:0] masked_d = d & {4{sel_d}};

// Combine all masked outputs
wire [3:0] combined_out = masked_b | masked_e | masked_a | masked_d;

// Output combined result or 'f' if c is outside 0-3
assign q = (c < 4'd4) ? combined_out : 4'b1111;

endmodule