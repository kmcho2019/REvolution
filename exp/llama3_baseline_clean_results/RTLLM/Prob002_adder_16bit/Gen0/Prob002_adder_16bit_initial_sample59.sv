// Define the 1-bit full adder module
module full_adder_1bit(
    input  a,
    input  b,
    input  Cin,
    output Cout,
    output sum
);
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the 8-bit full adder module using ripple carry architecture
module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input  Cin,
    output [7:0] y,
    output Cout
);
    wire [7:1] carry;
    
    // First bit
    full_adder_1bit fa0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .Cout(carry[1]),
        .sum(y[0])
    );
    
    // Middle bits
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder_1bit fa(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i]),
                .Cout(carry[i+1]),
                .sum(y[i])
            );
        end
    endgenerate
    
    // Last bit carry out
    assign Cout = carry[8];
endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input  Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;
    
    // Lower 8 bits
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Cout(carry_middle)
    );
    
    // Upper 8 bits
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_middle),
        .y(y[15:8]),
        .Cout(Co)
    );
endmodule