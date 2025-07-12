module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Optimized carry chain using generate and vector operations
    // Uses: sum = a ^ b ^ cin, cout = (a & b) | (cin & (a ^ b))
    wire [8:0] carry;
    assign carry[0] = cin;
    
    // Generate sum and carry bits
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
        end
    endgenerate
    
    assign cout = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Explicitly named intermediate carry with documentation
    wire low_to_high_carry;  // Carry from lower 8 bits to upper 8 bits
    
    // Lower 8-bit adder (LSBs)
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(low_to_high_carry)
    );
    
    // Upper 8-bit adder (MSBs)
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(low_to_high_carry),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule