// Define a module for a full adder cell
module full_adder_cell(
    input a,
    input b,
    input Cin,
    output Cout,
    output y
);
    assign y = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define a module for an 8-bit adder using full adder cells
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Cout
);
    wire [6:0] carry;
    
    full_adder_cell fa0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .Cout(carry[0]),
       .y(y[0])
    );
    
    // Instantiate full adder cells for bits 1 through 7
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder_cell fa(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .Cout(carry[i]),
               .y(y[i])
            );
        end
    endgenerate
    
    // The carry-out from the last full adder cell is the Cout of the 8-bit adder
    assign Cout = carry[6];
endmodule

// Define the module for the 16-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Cout_lower;
    
    // Instantiate an 8-bit adder for the lower bits
    adder_8bit lower_adder(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Cout(Cout_lower)
    );
    
    // Instantiate an 8-bit adder for the higher bits
    adder_8bit upper_adder(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(Cout_lower),
       .y(y[15:8]),
       .Cout(Co)
    );
endmodule