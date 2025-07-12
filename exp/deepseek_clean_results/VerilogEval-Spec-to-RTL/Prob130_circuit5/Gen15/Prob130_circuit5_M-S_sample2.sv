module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

assign q = (|c[3:2]) ? 4'b1111 :  // Default case when c >= 4
           (c[1:0] == 2'b00) ? b : // Select b when c == 0
           (c[1:0] == 2'b01) ? e : // Select e when c == 1
           (c[1:0] == 2'b10) ? a : // Select a when c == 2
           d;                      // Select d when c == 3

endmodule