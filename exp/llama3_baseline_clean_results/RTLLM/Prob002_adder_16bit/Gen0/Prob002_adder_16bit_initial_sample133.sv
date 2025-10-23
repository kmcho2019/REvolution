// Full Adder Cell (1-bit adder)
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit Adder
module adder_8bit(a, b, cin, y, cout);
    input [7:0] a, b;
    input cin;
    output [7:0] y;
    output cout;

    wire [6:0] carry;

    full_adder fa0(a[0], b[0], cin, y[0], carry[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(a[i], b[i], carry[i-1], y[i], carry[i]);
        end
    endgenerate
    assign cout = carry[7];
endmodule

// 16-bit Adder using two 8-bit adders
module adder_16bit(a, b, cin, y, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] y;
    output cout;

    wire cout_8bit;

    adder_8bit adder_low(a[7:0], b[7:0], cin, y[7:0], cout_8bit);
    adder_8bit adder_high(a[15:8], b[15:8], cout_8bit, y[15:8], cout);
endmodule