// Define the 8-bit adder module
module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] sum;
    assign sum = a + b + Cin;
    assign y = sum[7:0];
    assign Co = (sum > 8'd255) ? 1'b1 : 1'b0;
endmodule

// Define the 16-bit adder module
module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co1;
    adder_8bit adder_lower(.a(a[7:0]), .b(b[7:0]), .Cin(Cin), .y(y[7:0]), .Co(Co1));
    adder_8bit adder_upper(.a(a[15:8]), .b(b[15:8]), .Cin(Co1), .y(y[15:8]), .Co(Co));
endmodule

// Test the 16-bit adder module
module testbench;
    reg [15:0] a;
    reg [15:0] b;
    reg Cin;
    wire [15:0] y;
    wire Co;

    adder_16bit adder(.a(a), .b(b), .Cin(Cin), .y(y), .Co(Co));

    initial begin
        a = 16'd10;
        b = 16'd20;
        Cin = 1'b0;
        #10;
        $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);

        a = 16'd100;
        b = 16'd200;
        Cin = 1'b1;
        #10;
        $display("a = %h, b = %h, Cin = %b, y = %h, Co = %b", a, b, Cin, y, Co);
    end
endmodule