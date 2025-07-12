// Full adder module - bit-level adder
module full_adder (
    input  wire a,    // 1-bit input operand A
    input  wire b,    // 1-bit input operand B
    input  wire cin,  // Carry-in input
    output wire sum,  // 1-bit sum output
    output wire cout  // Carry-out output
);
    assign sum  = a ^ b ^ cin;              // Sum = A xor B xor Cin
    assign cout = (a & b) | (a & cin) | (b & cin); // Carry-out
endmodule

// 8-bit adder module using ripple carry of full adders
module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // Carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // Carry-out output
);
    wire [7:0] carry; // Internal carry signals between full adders

    // Instantiate 8 full adders for each bit
    // First full adder gets external cin
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Full adders 1 to 6
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : full_adder_chain
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Final carry-out from MSB full adder
    assign cout = carry[7];

endmodule