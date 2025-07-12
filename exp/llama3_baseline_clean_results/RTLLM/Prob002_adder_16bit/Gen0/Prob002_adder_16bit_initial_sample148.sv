// Define the 8-bit full adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] y_int;
    wire [7:0] carry;

    // Generate carry for each bit
    assign carry[0] = a[0] & b[0] | (a[0] & Cin) | (b[0] & Cin);
    assign y_int[0] = a[0] ^ b[0] ^ Cin;

    // Use the carry from the previous bit for the next
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign carry[i] = y_int[i-1] & (a[i] | b[i]) | (a[i] & b[i]);
            assign y_int[i] = a[i] ^ b[i] ^ (carry[i-1]);
        end
    endgenerate

    // Assign the final outputs
    assign y = y_int;
    assign Co = carry[7];
endmodule

// Define the 16-bit full adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co_8bit;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit u_adder_8bit_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Co_8bit)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit u_adder_8bit_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_8bit),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule