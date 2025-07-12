module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] s,
    output reg overflow
);
    // Declare signed versions of inputs and sum for arithmetic
    wire signed [7:0] signed_a = a;
    wire signed [7:0] signed_b = b;
    reg signed [8:0] extended_sum;  // 9-bit to detect carry out if needed

    always @* begin
        extended_sum = signed_a + signed_b;
        s = extended_sum[7:0];

        // Overflow detection:
        // If a and b have same sign but sum sign differs, overflow occurred
        if ((signed_a[7] == signed_b[7]) && (s[7] != signed_a[7]))
            overflow = 1'b1;
        else
            overflow = 1'b0;
    end
endmodule