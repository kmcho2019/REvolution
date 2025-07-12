// Define the module for a 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for an n-bit full adder using 1-bit adders
module adder_nbit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [15:0] carry;

    // Calculate carry for each bit position
    assign carry[0] = Cin;
    generate
        for (genvar i = 1; i < 16; i++) begin
            adder_1bit adder_inst(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .y(y[i]),
               .Co(carry[i])
            );
        end
    endgenerate

    // Final carry out
    assign Co = carry[15];
endmodule