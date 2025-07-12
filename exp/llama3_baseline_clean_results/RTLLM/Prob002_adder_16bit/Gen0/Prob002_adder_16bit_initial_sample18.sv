// Define a module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;
    assign carry[0] = Cin;
    
    // Iterate over each bit to compute sum and carry
    for (genvar i = 0; i < 8; i++) begin
        // For each bit position, calculate sum and carry
        full_adder fa(
            .a(a[i]),
            .b(b[i]),
            .Cin(carry[i]),
            .y(y[i]),
            .Co(carry[i+1])
        );
    end

    // The carry-out of the last full adder is the overall Co
    assign Co = carry[8];

endmodule

// Define the module for a single-bit full adder
module full_adder(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
    
endmodule

// Define the main 16-bit adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire Co_8bit;

    // First 8-bit adder for lower bits
    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co_8bit)
    );

    // Second 8-bit adder for upper bits
    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_8bit),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule