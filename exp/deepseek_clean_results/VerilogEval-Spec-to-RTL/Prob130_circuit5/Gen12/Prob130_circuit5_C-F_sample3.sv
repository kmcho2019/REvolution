module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect when c is less than 4 (c[3:2] == 0)
wire valid_selection = ~(|c[3:2]);

// Generate selection signals in parallel
wire select_b = valid_selection & (c[1:0] == 2'b00);
wire select_e = valid_selection & (c[1:0] == 2'b01);
wire select_a = valid_selection & (c[1:0] == 2'b10);
wire select_d = valid_selection & (c[1:0] == 2'b11);

// Combine selected inputs using bitwise operations
assign q = (select_b ? b : 4'b0) |
           (select_e ? e : 4'b0) |
           (select_a ? a : 4'b0) |
           (select_d ? d : 4'b0) |
           (valid_selection ? 4'b0 : 4'b1111);

endmodule