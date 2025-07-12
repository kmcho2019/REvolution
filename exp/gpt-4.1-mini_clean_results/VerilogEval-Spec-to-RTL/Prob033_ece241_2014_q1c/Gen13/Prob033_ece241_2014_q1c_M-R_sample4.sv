module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output reg       overflow
);
    reg [8:0] full_sum; // 9 bits to detect carry-out for clarity (not required for overflow detection)

    always @* begin
        full_sum = {1'b0, a} + {1'b0, b};
        s = full_sum[7:0];

        // Overflow detection for 2's complement addition:
        // Overflow if a and b have same sign, but sum has different sign
        overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
    end
endmodule