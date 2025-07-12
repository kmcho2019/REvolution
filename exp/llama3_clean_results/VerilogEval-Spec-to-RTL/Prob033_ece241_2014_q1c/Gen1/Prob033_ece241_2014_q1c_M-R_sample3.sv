module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    reg [7:0] sum;
    reg ovf;

    always @(*) begin
        sum = a + b;
        ovf = (a[7] == b[7] && a[7]!= sum[7]);
    end

    assign s = sum;
    assign overflow = ovf;

endmodule