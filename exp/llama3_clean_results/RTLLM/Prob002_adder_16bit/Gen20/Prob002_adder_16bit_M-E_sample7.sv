// Define the module for a 4-bit ripple carry adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for carry propagation
    wire [3:0] c;

    // Calculate output and carry for each bit
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign c[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
    assign y[1] = a[1] ^ b[1] ^ c[0];
    assign c[1] = (a[1] & b[1]) | (a[1] & c[0]) | (b[1] & c[0]);
    assign y[2] = a[2] ^ b[2] ^ c[1];
    assign c[2] = (a[2] & b[2]) | (a[2] & c[1]) | (b[2] & c[1]);
    assign y[3] = a[3] ^ b[3] ^ c[2];
    assign c[3] = (a[3] & b[3]) | (a[3] & c[2]) | (b[3] & c[2]);
    assign Co = c[3];

endmodule

// Define the module for a 16-bit full adder using four 4-bit ripple carry adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry propagation
    wire carry_4bit_1, carry_4bit_2, carry_4bit_3;

    // Instantiate the least significant 4-bit adder
    adder_4bit adder_ls(
      .a(a[3:0]),
      .b(b[3:0]),
      .Cin(Cin),
      .y(y[3:0]),
      .Co(carry_4bit_1)
    );

    // Instantiate the second 4-bit adder
    adder_4bit adder_2(
      .a(a[7:4]),
      .b(b[7:4]),
      .Cin(carry_4bit_1),
      .y(y[7:4]),
      .Co(carry_4bit_2)
    );

    // Instantiate the third 4-bit adder
    adder_4bit adder_3(
      .a(a[11:8]),
      .b(b[11:8]),
      .Cin(carry_4bit_2),
      .y(y[11:8]),
      .Co(carry_4bit_3)
    );

    // Instantiate the most significant 4-bit adder
    adder_4bit adder_ms(
      .a(a[15:12]),
      .b(b[15:12]),
      .Cin(carry_4bit_3),
      .y(y[15:12]),
      .Co(Co)
    );

endmodule

// Define a testbench for the 16-bit full adder
module tb_adder_16bit;
reg [15:0] a;
reg [15:0] b;
reg Cin;
wire [15:0] y;
wire Co;

adder_16bit uut(
   .a(a),
   .b(b),
   .Cin(Cin),
   .y(y),
   .Co(Co)
);

initial begin
    a = 16'd1;
    b = 16'd2;
    Cin = 1'b0;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    a = 16'd10;
    b = 16'd20;
    Cin = 1'b1;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    $finish;
end

endmodule