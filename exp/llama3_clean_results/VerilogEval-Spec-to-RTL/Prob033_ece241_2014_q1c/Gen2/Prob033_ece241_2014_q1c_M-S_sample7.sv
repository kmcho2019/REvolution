module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    always @(*) begin
        s = a + b;
        overflow = (a[7] == b[7] && a[7]!= s[7]);
    end

endmodule