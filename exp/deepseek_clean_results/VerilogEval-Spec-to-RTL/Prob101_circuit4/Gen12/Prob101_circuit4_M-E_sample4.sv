module TopModule (
    input  a, b, c, d,
    output q
);
    wire [1:0] vote_count = b + c + d;
    assign q = a ? 1'b0 : (vote_count >= 2'd2);
endmodule