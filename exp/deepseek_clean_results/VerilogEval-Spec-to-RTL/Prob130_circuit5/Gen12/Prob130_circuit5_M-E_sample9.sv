module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early termination for invalid cases (c >= 4)
wire invalid = |c[3:2];

// 2-to-4 decoder for valid selection
wire [3:0] sel;
assign sel[0] = ~invalid & (c[1:0] == 2'b00);  // Select b
assign sel[1] = ~invalid & (c[1:0] == 2'b01);  // Select e
assign sel[2] = ~invalid & (c[1:0] == 2'b10);  // Select a
assign sel[3] = ~invalid & (c[1:0] == 2'b11);  // Select d

// Parallel input selection
assign q = ({4{sel[0]}} & b) |
           ({4{sel[1]}} & e) |
           ({4{sel[2]}} & a) |
           ({4{sel[3]}} & d) |
           {4{invalid}};      // Default to all 1's if invalid

endmodule