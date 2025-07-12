module TopModule(
    input [2:0] a,
    output [15:0] q
);

assign q = 16'h1232 + (a * 16'h157c);

endmodule