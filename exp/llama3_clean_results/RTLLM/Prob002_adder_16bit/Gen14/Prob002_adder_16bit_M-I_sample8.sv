// Define the module for a 4-bit full adder using a carry-lookahead approach
module adder_4bit_cla(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for carry
    wire [3:0] g;  // generate signals
    wire [3:0] p;  // propagate signals
    wire [3:0] c;  // carry signals

    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] ^ b[3];

    // Calculate carry signals
    assign c[0] = Cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);

    // Calculate sum signals
    assign y[0] = a[0] ^ b[0] ^ c[0];
    assign y[1] = a[1] ^ b[1] ^ c[1];
    assign y[2] = a[2] ^ b[2] ^ c[2];
    assign y[3] = a[3] ^ b[3] ^ c[3];

    // Assign Co
    assign Co = g[3] | (p[3] & c[3]);

endmodule

// Define the module for an 8-bit full adder using two 4-bit adders
module adder_8bit_cla(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire C1;

    // Instantiate two 4-bit adders
    adder_4bit_cla adder_ls(
      .a(a[3:0]),
      .b(b[3:0]),
      .Cin(Cin),
      .y(y[3:0]),
      .Co(C1)
    );

    adder_4bit_cla adder_ms(
      .a(a[7:4]),
      .b(b[7:4]),
      .Cin(C1),
      .y(y[7:4]),
      .Co(Co)
    );

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit_cla(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two 8-bit adders
    adder_8bit_cla adder_lower(
      .a(a[7:0]),
      .b(b[7:0]),
      .Cin(Cin),
      .y(y[7:0]),
      .Co(C1)
    );

    adder_8bit_cla adder_upper(
      .a(a[15:8]),
      .b(b[15:8]),
      .Cin(C1),
      .y(y[15:8]),
      .Co(Co)
    );

endmodule

// Define a testbench for the 16-bit full adder
module tb_adder_16bit_cla;
reg [15:0] a;
reg [15:0] b;
reg Cin;
wire [15:0] y;
wire Co;

adder_16bit_cla uut(
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