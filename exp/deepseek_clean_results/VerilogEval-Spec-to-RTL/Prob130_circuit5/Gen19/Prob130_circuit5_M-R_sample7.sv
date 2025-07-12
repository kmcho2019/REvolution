module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (|c[3:2]) ? 4'b1111 :  // Output 'f' if c[3:2] not zero
           (c == 0)  ? b :        // c=0 selects b
           (c == 1)  ? e :        // c=1 selects e
           (c == 2)  ? a :        // c=2 selects a
           (c == 3)  ? d :        // c=3 selects d
           4'b1111;               // Default to 'f' (shouldn't reach here for c<4)

endmodule