// Define the module for an 8-bit Ripple Carry Adder (RCA)
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal signals for carry
    wire [7:0] c;

    // Calculate carry and output
    assign c[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);
    assign y[1] = a[1] ^ b[1] ^ c[1];
    assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
    assign y[2] = a[2] ^ b[2] ^ c[2];
    assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
    assign y[3] = a[3] ^ b[3] ^ c[3];
    assign c[4] = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);
    assign y[4] = a[4] ^ b[4] ^ c[4];
    assign c[5] = (a[4] & b[4]) | (a[4] & c[4]) | (b[4] & c[4]);
    assign y[5] = a[5] ^ b[5] ^ c[5];
    assign c[6] = (a[5] & b[5]) | (a[5] & c[5]) | (b[5] & c[5]);
    assign y[6] = a[6] ^ b[6] ^ c[6];
    assign c[7] = (a[6] & b[6]) | (a[6] & c[6]) | (b[6] & c[6]);
    assign y[7] = a[7] ^ b[7] ^ c[7];
    assign Co = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);

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