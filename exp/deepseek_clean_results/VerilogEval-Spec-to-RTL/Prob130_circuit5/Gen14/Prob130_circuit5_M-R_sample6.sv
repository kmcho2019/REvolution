module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Output is selected based on c[1:0], or 'f' if c[3] or c[2] is set
assign q = (c[3] | c[2]) ? 4'b1111 :  // Default case when c > 3
            (c[1:0] == 2'b00) ? b :   // Case 0: select b
            (c[1:0] == 2'b01) ? e :    // Case 1: select e
            (c[1:0] == 2'b10) ? a :    // Case 2: select a
            d;                         // Case 3: select d

endmodule