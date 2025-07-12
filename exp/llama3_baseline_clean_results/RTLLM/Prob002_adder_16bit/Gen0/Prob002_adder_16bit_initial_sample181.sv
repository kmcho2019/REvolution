// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,  // 8-bit input operand A
    input [7:0] b,  // 8-bit input operand B
    input Cin,      // Carry-in input
    output [7:0] y, // 8-bit output representing the sum of A and B
    output Co        // Carry-out output
);
    
    // Declare a temporary variable to store the carry
    wire [7:0] sum;
    wire [7:0] carry;

    // Perform the addition bit by bit
    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For bits 1 to 7, use the same logic, propagating the carry
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Assign the final sum and carry-out
    assign y = sum;
    assign Co = carry[7];
endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,  // 16-bit input operand A
    input [15:0] b,  // 16-bit input operand B
    input Cin,        // Carry-in input
    output [15:0] y, // 16-bit output representing the sum of A and B
    output Co         // Carry-out output
);

    // Instantiate the 8-bit adder for the lower 8 bits
    wire [7:0] sum_low;
    wire Co_low;
    adder_8bit u_adder_low(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(sum_low), 
        .Co(Co_low)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    wire [7:0] sum_high;
    wire Co_high;
    adder_8bit u_adder_high(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(Co_low), 
        .y(sum_high), 
        .Co(Co_high)
    );

    // Assign the final sum and carry-out
    assign y[7:0] = sum_low;
    assign y[15:8] = sum_high;
    assign Co = Co_high;
endmodule