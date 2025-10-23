module RippleCarryAdder8 (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [7:0] c; // carry signals between bits
    
    // Bit 0
    assign c[0] = cin;
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);
    
    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ c[1];
    assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
    
    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ c[2];
    assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
    
    // Bit 3
    assign sum[3] = a[3] ^ b[3] ^ c[3];
    assign c[4] = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);
    
    // Bit 4
    assign sum[4] = a[4] ^ b[4] ^ c[4];
    assign c[5] = (a[4] & b[4]) | (a[4] & c[4]) | (b[4] & c[4]);
    
    // Bit 5
    assign sum[5] = a[5] ^ b[5] ^ c[5];
    assign c[6] = (a[5] & b[5]) | (a[5] & c[5]) | (b[5] & c[5]);
    
    // Bit 6
    assign sum[6] = a[6] ^ b[6] ^ c[6];
    assign c[7] = (a[6] & b[6]) | (a[6] & c[6]) | (b[6] & c[6]);
    
    // Bit 7 (MSB)
    assign sum[7] = a[7] ^ b[7] ^ c[7];
    assign cout = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);
    
    // carry into MSB is c[7]
    assign carry_into_msb = c[7];
    
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout;
    wire carry_into_msb;
    
    RippleCarryAdder8 ripple_adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Overflow = carry_into_msb XOR carry_out_of_msb
    assign overflow = carry_into_msb ^ cout;

endmodule