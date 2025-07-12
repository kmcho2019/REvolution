// Single-bit full adder with combinational logic
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

// 8-bit ripple carry adder using generate loop for instantiation
module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    wire [7:0] carry;  // intermediate carry signals

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            if (i == 0) begin
                bit_full_adder fa (
                    .a(a[i]), .b(b[i]), .cin(cin),
                    .sum(sum[i]), .cout(carry[i])
                );
            end else begin
                bit_full_adder fa (
                    .a(a[i]), .b(b[i]), .cin(carry[i-1]),
                    .sum(sum[i]), .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[7];
endmodule