// Full Adder Module
module full_adder(
    input a,      // Input A
    input b,      // Input B
    input cin,    // Carry Input
    output sum,   // Sum Output
    output cout   // Carry Output
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit Adder Module
module adder_8bit(
    input [7:0] a,   // 8-bit Input Operand A
    input [7:0] b,   // 8-bit Input Operand B
    input cin,      // Carry Input
    output [7:0] sum, // 8-bit Output Sum
    output cout     // Carry Output
);
    wire [6:0] carry; // Internal Carry Wires
    
    // First Full Adder (Least Significant Bit)
    full_adder fa0(a[0], b[0], cin, sum[0], carry[0]);
    
    // Intermediate Full Adders
    generate
        for (genvar i = 1; i < 7; i++) begin
            full_adder fa_i(a[i], b[i], carry[i-1], sum[i], carry[i]);
        end
    endgenerate
    
    // Last Full Adder (Most Significant Bit)
    full_adder fa7(a[7], b[7], carry[6], sum[7], cout);
endmodule