// Define the 1-bit full adder module
module full_adder(
    input  a,
    input  b,
    input  Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the 8-bit full adder module
module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    
    // Internal carry signals
    wire [7:1] carry;
    
    // Perform addition for each bit
    full_adder fa0(a[0], b[0], Cin, y[0], carry[1]);
    for (genvar i = 1; i < 8; i++) begin
        full_adder fa(a[i], b[i], carry[i], y[i], carry[i+1]);
    end
    assign Co = carry[7];
endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input        Cin,
    output [15:0] y,
    output       Co
);
    
    // Internal carry signal
    wire carry;
    
    // Instantiate two 8-bit adders
    adder_8bit adder_lower(a[7:0], b[7:0], Cin, y[7:0], carry);
    adder_8bit adder_upper(a[15:8], b[15:8], carry, y[15:8], Co);
endmodule