module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] base = {4{a}} ^ {a, a, a, a};
wire [15:0] modifier = {a, ~a, a[1:0], a[2:1]} << a;

assign q = base ^ modifier ^ 
           (a[0] ? 16'h1000 : 16'h0200) ^ 
           (a[1] ? 16'h0080 : 16'h0040) ^ 
           (a[2] ? 16'h0002 : 16'h0001);

endmodule