// Define the module for a 4-bit carry-lookahead adder
module adder_4bit_cla(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Generate block for the sum and carry logic
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // Calculate the sum
            assign y[i] = a[i] ^ b[i] ^ (i == 0 ? Cin : (a[i-1] & b[i-1]) | (a[i-1] & (i == 1 ? Cin : (a[i-2] & b[i-2]))));
            
            // Calculate the carry
            if (i == 0) begin
                assign Co = (a[3] & b[3]) | (a[3] & (a[2] & b[2])) | (b[3] & (a[2] & b[2]));
            end else begin
                assign Co = (a[i] & b[i]) | (a[i] & (a[i-1] & b[i-1])) | (b[i] & (a[i-1] & b[i-1]));
            end
        end
    endgenerate

endmodule

// Define the module for the 16-bit full adder using four 4-bit carry-lookahead adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_4bit_1, carry_4bit_2, carry_4bit_3;

    // Instantiate the least significant 4-bit adder
    adder_4bit_cla adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry_4bit_1)
    );

    // Instantiate the second 4-bit adder
    adder_4bit_cla adder_2(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_4bit_1),
        .y(y[7:4]),
        .Co(carry_4bit_2)
    );

    // Instantiate the third 4-bit adder
    adder_4bit_cla adder_3(
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(carry_4bit_2),
        .y(y[11:8]),
        .Co(carry_4bit_3)
    );

    // Instantiate the most significant 4-bit adder
    adder_4bit_cla adder_ms(
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(carry_4bit_3),
        .y(y[15:12]),
        .Co(Co)
    );

endmodule