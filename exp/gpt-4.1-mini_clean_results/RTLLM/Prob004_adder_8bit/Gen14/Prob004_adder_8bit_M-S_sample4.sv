// Single-bit full adder using combinational assign statements
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

// 8-bit ripple carry adder using generate loop for cleaner code
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] c; // internal carry signals between bits

    // Instantiate first full adder with external carry-in
    bit_full_adder fa0 (
        .a(a[0]), .b(b[0]), .cin(cin),
        .sum(sum[0]), .cout(c[0])
    );

    // Generate the remaining 7 full adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_fa
            bit_full_adder fa (
                .a(a[i]), .b(b[i]), .cin(c[i-1]),
                .sum(sum[i]), .cout(c[i])
            );
        end
    endgenerate

    assign cout = c[7];
endmodule