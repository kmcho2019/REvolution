module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (c > 4'b0011) ? 4'b1111 :  // Default case when c > 3
           (c == 4'b0000) ? b :       // Case 0: select b
           (c == 4'b0001) ? e :        // Case 1: select e
           (c == 4'b0010) ? a :        // Case 2: select a
           d;                          // Case 3: select d

endmodule