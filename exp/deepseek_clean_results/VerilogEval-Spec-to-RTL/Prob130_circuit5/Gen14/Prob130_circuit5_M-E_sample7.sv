module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Early termination for invalid cases (c >= 4)
wire invalid_case = |c[3:2];

// Decode only valid cases (c < 4)
wire sel_b = ~invalid_case & (c[1:0] == 2'b00);
wire sel_e = ~invalid_case & (c[1:0] == 2'b01);
wire sel_a = ~invalid_case & (c[1:0] == 2'b10);
wire sel_d = ~invalid_case & (c[1:0] == 2'b11);

// Combine selected inputs
assign q = invalid_case ? 4'b1111 : 
           (sel_b ? b : 
           (sel_e ? e : 
           (sel_a ? a : d)));

endmodule