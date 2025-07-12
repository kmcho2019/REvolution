// Define the module for a 4-bit full adder with look-ahead carry generation
module adder_4bit_lac(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for carry generation
    wire [3:0] carry;

    // Generate block for all bits
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            if (i == 0) begin
                assign y[i] = a[i] ^ b[i] ^ Cin;
                assign carry[i] = (a[i] & b[i]) | (a[i] & Cin) | (b[i] & Cin);
            end else begin
                assign y[i] = a[i] ^ b[i] ^ carry[i-1];
                assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            end
        end
    endgenerate

    // Assign Co using look-ahead carry generation
    assign Co = (a[3] & b[3] & carry[2]) | (a[3] & carry[2] & carry[1]) | (b[3] & carry[2] & carry[1]) | (a[3] & b[3] & carry[1]) | (a[2] & b[2] & carry[1]) | (a[2] & carry[1] & carry[0]) | (b[2] & carry[1] & carry[0]) | (a[2] & b[2] & carry[0]) | (a[1] & b[1] & carry[0]) | (a[1] & carry[0] & Cin) | (b[1] & carry[0] & Cin) | (a[1] & b[1] & Cin);

endmodule

// Define the module for a 16-bit full adder using four 4-bit adders with look-ahead carry
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_4bit_1, carry_4bit_2, carry_4bit_3;

    // Instantiate the least significant 4-bit adder
    adder_4bit_lac adder_ls(
      .a(a[3:0]),
      .b(b[3:0]),
      .Cin(Cin),
      .y(y[3:0]),
      .Co(carry_4bit_1)
    );

    // Instantiate the second 4-bit adder
    adder_4bit_lac adder_2(
      .a(a[7:4]),
      .b(b[7:4]),
      .Cin(carry_4bit_1),
      .y(y[7:4]),
      .Co(carry_4bit_2)
    );

    // Instantiate the third 4-bit adder
    adder_4bit_lac adder_3(
      .a(a[11:8]),
      .b(b[11:8]),
      .Cin(carry_4bit_2),
      .y(y[11:8]),
      .Co(carry_4bit_3)
    );

    // Instantiate the most significant 4-bit adder
    adder_4bit_lac adder_ms(
      .a(a[15:12]),
      .b(b[15:12]),
      .Cin(carry_4bit_3),
      .y(y[15:12]),
      .Co(Co)
    );

endmodule