module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire [7:0] c; // carry signals between full adders: c[0] to c[7]
wire [7:0] sum_bits;

// carry-in for the first bit is zero
assign c[0] = 1'b0;

// Full Adder module instantiation for each bit
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_full_adders
        FullAdder FA (
            .a(a[i]),
            .b(b[i]),
            .cin(c[i]),
            .sum(s[i]),
            .cout(c[i+1])
        );
    end
endgenerate

// For the generate block above, c[8] is needed but c declared only to c[7].
// Fixing: define wire [8:0] c; to hold 9 carry signals (c[0] to c[8])

// Corrected: redefine c as 9 bits
wire [8:0] c;
assign c[0] = 1'b0;

generate
    for (i = 0; i < 8; i = i + 1) begin : gen_full_adders_fixed
        FullAdder FA (
            .a(a[i]),
            .b(b[i]),
            .cin(c[i]),
            .sum(s[i]),
            .cout(c[i+1])
        );
    end
endgenerate

// Overflow detection:
// overflow = carry-in to MSB bit XOR carry-out from MSB bit
assign overflow = c[7] ^ c[8];

endmodule

// Full adder definition
module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule