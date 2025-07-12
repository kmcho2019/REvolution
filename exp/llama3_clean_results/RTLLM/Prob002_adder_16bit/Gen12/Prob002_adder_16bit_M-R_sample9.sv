// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

// Generate block for bits 0 to 7
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        // For the first bit, use Cin as the carry-in
        if (i == 0) begin
            assign y[i] = a[i] ^ b[i] ^ Cin;
        // For subsequent bits, use the carry from the previous bit
        end else begin
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
        end
        // Calculate carry for each bit
        if (i == 0) begin
            wire carry0 = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
            assign carry[0] = carry0;
        end else begin
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    end
endgenerate

// Assign Co
assign Co = carry[7];

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

// Internal signal for carry from the least significant 8-bit adder
wire carry_8bit;

// Instantiate the least significant 8-bit adder
adder_8bit adder_ls(
   .a(a[7:0]),
   .b(b[7:0]),
   .Cin(Cin),
   .y(y[7:0]),
   .Co(carry_8bit)
);

// Instantiate the most significant 8-bit adder
adder_8bit adder_ms(
   .a(a[15:8]),
   .b(b[15:8]),
   .Cin(carry_8bit),
   .y(y[15:8]),
   .Co(Co)
);

endmodule