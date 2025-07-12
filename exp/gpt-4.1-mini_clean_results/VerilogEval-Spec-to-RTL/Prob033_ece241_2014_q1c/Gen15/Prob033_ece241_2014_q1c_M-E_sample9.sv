module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] carry; // Internal carry signals

    // Instantiate 8 full adders in ripple carry chain
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : FA_CHAIN
            if (i == 0) begin
                FullAdder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(1'b0),
                    .sum(s[i]),
                    .cout(carry[i])
                );
            end else begin
                FullAdder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(s[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    // Signed overflow detection:
    // Overflow occurs if a and b have same sign but s has different sign
    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);

endmodule