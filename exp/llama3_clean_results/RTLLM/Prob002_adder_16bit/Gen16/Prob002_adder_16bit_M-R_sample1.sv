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

// Define the module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;

    // First bit (bit 0) adder
    adder_1bit adder_bit0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .y(y[0]),
       .Co(carry[0])
    );

    // Bits 1 to 7 adders
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            adder_1bit adder_bit(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .y(y[i]),
               .Co(carry[i])
            );
        end
    endgenerate

    // Assign Co
    assign Co = carry[7];

endmodule

// Define the module for a 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate the least significant 8-bit adder
    adder_8bit adder_ls(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(C1)
    );

    // Instantiate the most significant 8-bit adder
    adder_8bit adder_ms(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(C1),
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
    a = 16'd10;
    b = 16'd20;
    Cin = 1'b1;
    #10;
    $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    $finish;
end

endmodule