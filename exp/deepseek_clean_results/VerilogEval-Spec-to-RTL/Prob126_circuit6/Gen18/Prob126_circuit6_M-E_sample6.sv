module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Polynomial-style computation of output based on input bits
assign q = {4{a[2]}} ^ {8{a[1]}} ^ {16{a[0]}} ^ 
           ({16{a[2]}} & 16'h8421) ^ 
           ({16{a[1]}} & 16'h1248) ^ 
           ({16{a[0]}} & 16'h4812) ^ 
           ({16{a[2] & a[1]}} & 16'h2148) ^ 
           ({16{a[1] & a[0]}} & 16'h4281) ^ 
           ({16{a[2] & a[0]}} & 16'h1842) ^ 
           ({16{a[2] & a[1] & a[0]}} & 16'h8888);

endmodule