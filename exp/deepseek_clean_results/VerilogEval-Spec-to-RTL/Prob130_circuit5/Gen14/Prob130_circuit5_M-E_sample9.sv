module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Generate selection masks
wire [3:0] sel_b = {4{c == 4'b0000}};  // c=0 selects b
wire [3:0] sel_e = {4{c == 4'b0001}};  // c=1 selects e
wire [3:0] sel_a = {4{c == 4'b0010}};  // c=2 selects a
wire [3:0] sel_d = {4{c == 4'b0011}};  // c=3 selects d

// Apply masks to inputs
wire [3:0] masked_b = b & sel_b;
wire [3:0] masked_e = e & sel_e;
wire [3:0] masked_a = a & sel_a;
wire [3:0] masked_d = d & sel_d;

// Combine all masked inputs
wire [3:0] combined = masked_b | masked_e | masked_a | masked_d;

// Output is combined unless c[3:2] are not zero, then output 'f'
assign q = (|c[3:2]) ? 4'b1111 : combined;

endmodule