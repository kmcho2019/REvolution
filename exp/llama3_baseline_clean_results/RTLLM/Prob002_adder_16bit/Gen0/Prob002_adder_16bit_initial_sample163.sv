// Module for a 1-bit full adder
module full_adder_1bit(
    input   a,
    input   b,
    input   Cin,
    output  sum,
    output  Cout
);
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Module for an 8-bit adder using the 1-bit full adder
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input   Cin,
    output  [7:0] y,
    output  Co
);
    wire [7:0] carry;
    
    // First bit does not have a previous carry, so Cin is used directly
    full_adder_1bit fa0(a[0], b[0], Cin, y[0], carry[0]);
    
    // Remaining bits use the carry from the previous bit
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder_1bit fa(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate
    
    // Final carry-out
    assign Co = carry[7];
endmodule

// Module for a 16-bit adder using two 8-bit adders
module adder_16bit(
    input   [15:0] a,
    input   [15:0] b,
    input   Cin,
    output  [15:0] y,
    output  Co
);
    wire carry_out_low;
    
    // Low byte (bits 7:0)
    adder_8bit adder_low(a[7:0], b[7:0], Cin, y[7:0], carry_out_low);
    
    // High byte (bits 15:8), using carry from low byte
    adder_8bit adder_high(a[15:8], b[15:8], carry_out_low, y[15:8], Co);
endmodule