module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output reg       overflow
);
    reg [8:0] sum;

    always @(*) begin
        sum = {1'b0, a} + {1'b0, b};
        s = sum[7:0];
        // Overflow occurs if a and b have the same sign, but sum has different sign
        overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);
    end
endmodule