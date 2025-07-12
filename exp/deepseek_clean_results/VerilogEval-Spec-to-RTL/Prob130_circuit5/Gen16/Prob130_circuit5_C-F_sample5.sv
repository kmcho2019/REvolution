module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect invalid cases (c >= 4) using just the upper bits
wire invalid_case = |c[3:2];

// Generate selection masks based on c[1:0] only when valid
wire [3:0] selected_input = 
    ({4{~invalid_case & (c[1:0] == 2'b00)}} & b) |
    ({4{~invalid_case & (c[1:0] == 2'b01)}} & e) |
    ({4{~invalid_case & (c[1:0] == 2'b10)}} & a) |
    ({4{~invalid_case & (c[1:0] == 2'b11)}} & d);

// Output selected input or all 1's for invalid cases
assign q = invalid_case ? 4'b1111 : selected_input;

endmodule