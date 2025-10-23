module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early detection of invalid cases (c >= 4)
wire invalid_case = c[2] | c[3];

// Parallel selection logic using c[1:0] only
wire [3:0] selected_input = 
    ({4{ c[1:0] == 2'b00 }} & b) |
    ({4{ c[1:0] == 2'b01 }} & e) |
    ({4{ c[1:0] == 2'b10 }} & a) |
    ({4{ c[1:0] == 2'b11 }} & d);

// Output selected input or all 1's for invalid cases
assign q = invalid_case ? 4'b1111 : selected_input;

endmodule