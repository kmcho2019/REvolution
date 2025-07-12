module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Enable signals for each valid case
wire en_b = (c == 4'b0000);
wire en_e = (c == 4'b0001);
wire en_a = (c == 4'b0010);
wire en_d = (c == 4'b0011);

// Mask each input with its enable
wire [3:0] masked_b = b & {4{en_b}};
wire [3:0] masked_e = e & {4{en_e}};
wire [3:0] masked_a = a & {4{en_a}};
wire [3:0] masked_d = d & {4{en_d}};

// Default case (c > 3)
wire default_case = |c[3:2];
wire [3:0] masked_default = {4{default_case}};

// Combine all cases
assign q = masked_b | masked_e | masked_a | masked_d | masked_default;

endmodule