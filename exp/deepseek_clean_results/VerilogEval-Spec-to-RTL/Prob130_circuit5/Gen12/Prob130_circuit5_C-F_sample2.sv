module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect valid selection cases (c < 4)
wire valid_selection = ~(|c[3:2]);

// Generate selection masks only when needed
wire [3:0] selected_input = 
    ({4{valid_selection & ~c[1] & ~c[0]}} & b) |
    ({4{valid_selection & ~c[1] &  c[0]}} & e) |
    ({4{valid_selection &  c[1] & ~c[0]}} & a) |
    ({4{valid_selection &  c[1] &  c[0]}} & d);

// Output selected input or 0xF if c[3] or c[2] is set
assign q = valid_selection ? selected_input : 4'b1111;

endmodule