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

// Define the module for a 4-bit adder using 4 1-bit adders
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    wire [2:0] carry;

    // Instantiate the 1-bit adders and chain them together
    adder_1bit adder_0(
      .a(a[0]),
      .b(b[0]),
      .Cin(Cin),
      .y(y[0]),
      .Co(carry[0])
    );

    generate
        for (genvar i = 1; i < 4; i++) begin
            adder_1bit adder_i(
              .a(a[i]),
              .b(b[i]),
              .Cin(carry[i-1]),
              .y(y[i]),
              .Co(carry[i])
            );
        end
    endgenerate

    // The carry-out of the last bit is the final Co
    assign Co = carry[3];
endmodule

// Define the module for an 8-bit adder using two 4-bit adders
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire Cin_4bit, Co_4bit;

    // Instantiate the first 4-bit adder for the lower bits
    adder_4bit adder_lower(
      .a(a[3:0]),
      .b(b[3:0]),
      .Cin(Cin),
      .y(y[3:0]),
      .Co(Cin_4bit)
    );

    // Instantiate the second 4-bit adder for the upper bits
    adder_4bit adder_upper(
      .a(a[7:4]),
      .b(b[7:4]),
      .Cin(Cin_4bit),
      .y(y[7:4]),
      .Co(Co)
    );
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire Co_8bit;

    // Instantiate the first 8-bit adder for the lower bits
    adder_8bit adder_lower(
      .a(a[7:0]),
      .b(b[7:0]),
      .Cin(Cin),
      .y(y[7:0]),
      .Co(Co_8bit)
    );

    // Instantiate the second 8-bit adder for the upper bits
    adder_8bit adder_upper(
      .a(a[15:8]),
      .b(b[15:8]),
      .Cin(Co_8bit),
      .y(y[15:8]),
      .Co(Co)
    );
endmodule