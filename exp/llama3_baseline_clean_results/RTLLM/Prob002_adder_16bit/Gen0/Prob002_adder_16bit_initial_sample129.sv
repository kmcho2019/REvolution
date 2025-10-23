// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal wire to connect partial sums and carries
    wire [7:0] partial_sum;
    wire [7:0] carry;

    // Generate the partial sum and carry for each bit position
    assign partial_sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // For bits 1 to 7, use the previous bit's carry as the current bit's Cin
    generate
        for (genvar i = 1; i < 8; i++) begin
            assign partial_sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // The final output y is the partial sum
    assign y = partial_sum;

    // The final carry-out Co is the carry from the most significant bit
    assign Co = carry[7];

endmodule

// Define the module for a 16-bit full adder using the 8-bit adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Instantiate two 8-bit adders
    wire [7:0] lower_sum;
    wire lower_carry;
    wire [7:0] upper_sum;
    wire upper_carry;

    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(lower_sum),
        .Co(lower_carry)
    );

    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(lower_carry),
        .y(upper_sum),
        .Co(upper_carry)
    );

    // Combine the sums from the two adders
    assign y = {upper_sum, lower_sum};

    // The final carry-out is from the upper adder
    assign Co = upper_carry;

endmodule