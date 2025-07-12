module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input cin,      // Carry-in input
    output [7:0] sum,  // 8-bit output representing the sum of A and B
    output cout      // Carry-out output
);

    wire [6:0] carry;  // Internal carry wires

    // First bit-level adder (bit 0)
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);

    // Subsequent bit-level adders (bits 1-7)
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate

    // Final carry-out
    assign cout = carry[7];

endmodule

// Full adder module used in the 8-bit adder
module full_adder(
    input a,  // Input bit A
    input b,  // Input bit B
    input cin,  // Carry-in
    output sum,  // Sum output
    output cout  // Carry-out
);

    assign sum = a ^ b ^ cin;  // Sum is XOR of inputs and carry-in
    assign cout = (a & b) | (a & cin) | (b & cin);  // Carry-out condition

endmodule