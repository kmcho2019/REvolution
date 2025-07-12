module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Expanded input patterns
wire [15:0] expanded_a = {5{a}};

// Output generation through bitwise operations
assign q = (a == 3'd0) ? expanded_a ^ 16'h1312 :
           (a == 3'd1) ? expanded_a ^ 16'hafc1 :
           (a == 3'd2) ? expanded_a ^ 16'h25c6 :
           (a == 3'd3) ? expanded_a ^ 16'h59c1 :
           (a == 3'd4) ? expanded_a ^ 16'h2156 :
           (a == 3'd5) ? expanded_a ^ 16'h65c1 :
           (a == 3'd6) ? expanded_a ^ 16'hc4c6 :
           (a == 3'd7) ? expanded_a ^ 16'h2ec9 :
           16'h0000;

endmodule