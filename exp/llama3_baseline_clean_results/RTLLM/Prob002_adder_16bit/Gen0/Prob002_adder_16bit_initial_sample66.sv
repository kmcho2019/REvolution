// Define the 1-bit full adder
module adder_1bit(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;
    wire sum, carry;

    // Calculate sum and carry
    assign sum = a ^ b ^ Cin;
    assign carry = (a & b) | (a & Cin) | (b & Cin);

    // Assign outputs
    assign y = sum;
    assign Co = carry;
endmodule

// Define the 8-bit adder using the 1-bit full adder
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] carry;

    // Instantiate 1-bit adders and chain them
    adder_1bit u0(a[0], b[0], Cin, y[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            adder_1bit u1(.a(a[i]), .b(b[i]), .Cin(carry[i-1]), .y(y[i]), .Co(carry[i]));
        end
    endgenerate
    assign Co = carry[7];
endmodule

// Define the 16-bit adder using two 8-bit adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire [7:0] lower_y, upper_y;
    wire lower_Co;

    // Lower 8 bits
    adder_8bit u_lower(a[7:0], b[7:0], Cin, lower_y, lower_Co);

    // Upper 8 bits
    adder_8bit u_upper(a[15:8], b[15:8], lower_Co, upper_y, Co);

    // Combine results
    assign y[7:0] = lower_y;
    assign y[15:8] = upper_y;
endmodule