module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    assign q = (a == 1'b1) ? ((b == 1'b1) ? 1'b1 : 1'b0) : 1'b0;
endmodule