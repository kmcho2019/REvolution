module TopModule (
    input  [2:0] a,
    output [15:0] q
);

assign q = {12'd0, a} * 16'd4660;

endmodule