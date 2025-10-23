module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Efficient condition detection
wire sel_b = (c == 4'd0);
wire sel_e = (c == 4'd1);
wire sel_a = (c == 4'd2);
wire sel_d = (c == 4'd3);
wire default_case = (c > 4'd3);  // Single comparison for range check

// Priority-encoded output selection
assign q = sel_b ? b :
           sel_e ? e :
           sel_a ? a :
           sel_d ? d :
           4'b1111;  // Default case (f)

endmodule