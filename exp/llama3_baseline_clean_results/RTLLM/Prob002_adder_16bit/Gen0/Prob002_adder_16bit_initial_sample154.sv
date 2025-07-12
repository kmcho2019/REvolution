// Define a 1-bit full adder
module full_adder_1bit(a, b, Cin, sum, Cout);
    input a, b, Cin;
    output sum, Cout;

    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define an 8-bit full adder using the 1-bit full adder
module full_adder_8bit(a, b, Cin, y, Cout);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Cout;

    wire [7:0] carry;

    full_adder_1bit fa0(a[0], b[0], Cin, y[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder_1bit fa(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate
    assign Cout = carry[7];
endmodule

// Define the 16-bit full adder using two 8-bit full adders
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire carry;

    full_adder_8bit fa_low(a[7:0], b[7:0], Cin, y[7:0], carry);
    full_adder_8bit fa_high(a[15:8], b[15:8], carry, y[15:8], Co);
endmodule

// Testbench for the 16-bit full adder
module tb_adder_16bit;
    reg [15:0] a, b;
    reg Cin;
    wire [15:0] y;
    wire Co;

    adder_16bit uut(a, b, Cin, y, Co);

    initial begin
        a = 16'h0000;
        b = 16'h0000;
        Cin = 1'b0;
        #10;
        a = 16'hFFFF;
        b = 16'hFFFF;
        Cin = 1'b1;
        #10;
        $finish;
    end
endmodule