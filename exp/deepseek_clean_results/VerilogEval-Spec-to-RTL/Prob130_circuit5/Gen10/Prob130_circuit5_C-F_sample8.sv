module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Generate selection signals for valid cases
wire select_b = (c == 4'd0);
wire select_e = (c == 4'd1);
wire select_a = (c == 4'd2);
wire select_d = (c == 4'd3);

// Combine inputs using bitwise masking
wire [3:0] selected_input = 
    (b & {4{select_b}}) |
    (e & {4{select_e}}) |
    (a & {4{select_a}}) |
    (d & {4{select_d}});

// Output selected input or 0xF for default case
assign q = (c > 4'd3) ? 4'b1111 : selected_input;

endmodule