// Single-bit full adder module
module bit_full_adder (
    input  wire a,      // single-bit input a
    input  wire b,      // single-bit input b
    input  wire cin,    // carry-in input
    output wire sum,    // sum output
    output wire cout    // carry-out output
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit ripple carry adder using generate loop and carry vector
module adder_8bit (
    input  wire [7:0] a,      // 8-bit input operand A
    input  wire [7:0] b,      // 8-bit input operand B
    input  wire       cin,    // carry-in input
    output wire [7:0] sum,    // 8-bit sum output
    output wire       cout    // carry-out output
);
    wire [7:0] c;  // carry signals; c[i] is carry-out from bit i adder

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_gen
            if (i == 0) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end else begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(c[i-1]),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end
        end
    endgenerate

    assign cout = c[7];
endmodule