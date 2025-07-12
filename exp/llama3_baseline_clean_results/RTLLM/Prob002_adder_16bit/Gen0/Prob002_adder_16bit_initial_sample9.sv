module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [7:0] sum;
    assign sum = a + b + Cin;
    assign y = sum[7:0];
    assign Co = (sum > 8'hFF);
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire Co_lower;
    adder_8bit adder_lower(
        .a(a[7:0]), 
        .b(b[7:0]), 
        .Cin(Cin), 
        .y(y[7:0]), 
        .Co(Co_lower)
    );

    adder_8bit adder_upper(
        .a(a[15:8]), 
        .b(b[15:8]), 
        .Cin(Co_lower), 
        .y(y[15:8]), 
        .Co(Co)
    );
endmodule