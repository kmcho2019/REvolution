module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Decode lower 2 bits of c for selection
wire [3:0] sel_decoder = 4'b1 << c[1:0];

// Generate selection masks
wire sel_b = sel_decoder[0];  // c[1:0] == 0
wire sel_e = sel_decoder[1];  // c[1:0] == 1
wire sel_a = sel_decoder[2];  // c[1:0] == 2
wire sel_d = sel_decoder[3];  // c[1:0] == 3

// Check for default case (c > 3)
wire default_case = |c[3:2];

// Generate output
assign q = default_case ? 4'b1111 : 
           (sel_b ? b : 
            sel_e ? e : 
            sel_a ? a : 
            d);  // sel_d is implied by elimination

endmodule