module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Generate selection masks based on c[1:0]
wire select_b = (c[1:0] == 2'b00);
wire select_e = (c[1:0] == 2'b01);
wire select_a = (c[1:0] == 2'b10);
wire select_d = (c[1:0] == 2'b11);

// Combine inputs using the selection masks
wire [3:0] selected_input = 
    ({4{select_b}} & b) |
    ({4{select_e}} & e) |
    ({4{select_a}} & a) |
    ({4{select_d}} & d);

// Output selected input or 0xF if c[3] or c[2] is set
assign q = (|c[3:2]) ? 4'b1111 : selected_input;

endmodule