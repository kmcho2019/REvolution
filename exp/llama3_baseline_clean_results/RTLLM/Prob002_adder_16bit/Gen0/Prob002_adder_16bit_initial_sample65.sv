// Full Adder Module
module full_adder(
    input a, b, Cin,
    output sum, Co
);
    assign sum = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit Adder Module
module adder_8bit(
    input [7:0] a, b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [6:0] carry;
    
    full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa_i(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate
    assign Co = carry[7];
endmodule

// 16-bit Adder Module
module adder_16bit(
    input [15:0] a, b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_8bit;
    
    adder_8bit adder_lo(a[7:0], b[7:0], Cin, y[7:0], carry_8bit);
    adder_8bit adder_hi(a[15:8], b[15:8], carry_8bit, y[15:8], Co);
endmodule