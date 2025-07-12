module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input carry_in,
    output [7:0] sum,
    output carry_out
);
    // Internal carry signals
    wire [7:0] carry_chain;
    
    // Bit 0
    assign sum[0] = a[0] ^ b[0] ^ carry_in;
    assign carry_chain[0] = (a[0] & b[0]) | (a[0] & carry_in) | (b[0] & carry_in);
    
    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ carry_chain[0];
    assign carry_chain[1] = (a[1] & b[1]) | (a[1] & carry_chain[0]) | (b[1] & carry_chain[0]);
    
    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ carry_chain[1];
    assign carry_chain[2] = (a[2] & b[2]) | (a[2] & carry_chain[1]) | (b[2] & carry_chain[1]);
    
    // Bit 3
    assign sum[3] = a[3] ^ b[3] ^ carry_chain[2];
    assign carry_chain[3] = (a[3] & b[3]) | (a[3] & carry_chain[2]) | (b[3] & carry_chain[2]);
    
    // Bit 4
    assign sum[4] = a[4] ^ b[4] ^ carry_chain[3];
    assign carry_chain[4] = (a[4] & b[4]) | (a[4] & carry_chain[3]) | (b[4] & carry_chain[3]);
    
    // Bit 5
    assign sum[5] = a[5] ^ b[5] ^ carry_chain[4];
    assign carry_chain[5] = (a[5] & b[5]) | (a[5] & carry_chain[4]) | (b[5] & carry_chain[4]);
    
    // Bit 6
    assign sum[6] = a[6] ^ b[6] ^ carry_chain[5];
    assign carry_chain[6] = (a[6] & b[6]) | (a[6] & carry_chain[5]) | (b[6] & carry_chain[5]);
    
    // Bit 7
    assign sum[7] = a[7] ^ b[7] ^ carry_chain[6];
    assign carry_out = (a[7] & b[7]) | (a[7] & carry_chain[6]) | (b[7] & carry_chain[6]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input carry_in,
    output [15:0] sum,
    output carry_out
);
    wire middle_carry;
    
    // Lower 8 bits
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .carry_in(carry_in),
        .sum(sum[7:0]),
        .carry_out(middle_carry)
    );
    
    // Upper 8 bits
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .carry_in(middle_carry),
        .sum(sum[15:8]),
        .carry_out(carry_out)
    );
endmodule