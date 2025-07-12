// Define the module for a 4-bit carry-save adder
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] sum,
    output [2:0] carry
);

    // Internal signals for sum and carry
    wire [3:0] sum_int;
    wire [2:0] carry_int;

    // Compute sum and carry for each bit position
    assign sum_int[0] = a[0] ^ b[0] ^ Cin;
    assign carry_int[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    assign sum_int[1] = a[1] ^ b[1] ^ carry_int[0];
    assign carry_int[1] = (a[1] & b[1]) | (a[1] & carry_int[0]) | (b[1] & carry_int[0]);

    assign sum_int[2] = a[2] ^ b[2] ^ carry_int[1];
    assign carry[0] = (a[2] & b[2]) | (a[2] & carry_int[1]) | (b[2] & carry_int[1]);

    assign sum_int[3] = a[3] ^ b[3] ^ carry_int[1];
    assign carry[1] = (a[3] & b[3]) | (a[3] & carry_int[1]) | (b[3] & carry_int[1]);

    assign sum = sum_int;
    assign carry[2] = carry_int[1];

endmodule

// Define the module for a 16-bit pipelined carry-save adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry and sum
    wire [2:0] carry_1, carry_2, carry_3;
    wire [3:0] sum_1, sum_2, sum_3, sum_4;

    // Stage 1: 4-bit carry-save adder for bits 0-3
    adder_4bit adder_1(
       .a(a[3:0]),
       .b(b[3:0]),
       .Cin(Cin),
       .sum(sum_1),
       .carry(carry_1)
    );

    // Stage 2: 4-bit carry-save adder for bits 4-7
    adder_4bit adder_2(
       .a(a[7:4]),
       .b(b[7:4]),
       .Cin(carry_1[2]),
       .sum(sum_2),
       .carry(carry_2)
    );

    // Stage 3: 4-bit carry-save adder for bits 8-11
    adder_4bit adder_3(
       .a(a[11:8]),
       .b(b[11:8]),
       .Cin(carry_2[2]),
       .sum(sum_3),
       .carry(carry_3)
    );

    // Stage 4: 4-bit carry-save adder for bits 12-15
    adder_4bit adder_4(
       .a(a[15:12]),
       .b(b[15:12]),
       .Cin(carry_3[2]),
       .sum(sum_4),
       .Co(Co)
    );

    // Combine the sum bits from each stage
    assign y[3:0] = sum_1;
    assign y[7:4] = sum_2;
    assign y[11:8] = sum_3;
    assign y[15:12] = sum_4;

endmodule

// Define a testbench for the 16-bit pipelined carry-save adder
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