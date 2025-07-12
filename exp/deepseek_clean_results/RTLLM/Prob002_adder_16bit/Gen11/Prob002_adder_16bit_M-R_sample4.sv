module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Calculate sum and carry in parallel
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ (a[0] & b[0] | (a[0] | b[0]) & cin);
    assign sum[2] = a[2] ^ b[2] ^ (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin));
    assign sum[3] = a[3] ^ b[3] ^ (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)));
    assign sum[4] = a[4] ^ b[4] ^ (a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin))));
    assign sum[5] = a[5] ^ b[5] ^ (a[4] & b[4] | (a[4] | b[4]) & (a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)))));
    assign sum[6] = a[6] ^ b[6] ^ (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & (a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)))));
    assign sum[7] = a[7] ^ b[7] ^ (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & (a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin)))));
    
    // Calculate final carry out
    assign cout = a[7] & b[7] | (a[7] | b[7]) & (a[6] & b[6] | (a[6] | b[6]) & (a[5] & b[5] | (a[5] | b[5]) & (a[4] & b[4] | (a[4] | b[4]) & (a[3] & b[3] | (a[3] | b[3]) & (a[2] & b[2] | (a[2] | b[2]) & (a[1] & b[1] | (a[1] | b[1]) & (a[0] & b[0] | (a[0] | b[0]) & cin))))));
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Intermediate carry between the two 8-bit adders
    wire carry_between;
    
    // Instantiate lower 8-bit adder (bits 7:0)
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_between)
    );
    
    // Instantiate upper 8-bit adder (bits 15:8)
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_between),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule