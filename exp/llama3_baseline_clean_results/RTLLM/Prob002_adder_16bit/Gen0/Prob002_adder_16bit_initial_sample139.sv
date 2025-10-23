module adder_1bit(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;
    assign {Co, y} = a + b + Cin;
endmodule

module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;
    wire [7:0] temp_y;
    wire [7:0] temp_c;

    // Create an array of 1-bit adders
    adder_1bit adder0(a[0], b[0], Cin, temp_y[0], temp_c[0]);
    generate
        for (genvar i = 1; i < 8; i++) begin
            adder_1bit adder(i)(a[i], b[i], temp_c[i-1], temp_y[i], temp_c[i]);
        end
    endgenerate

    assign y = temp_y;
    assign Co = temp_c[7];
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;

    wire [7:0] lower_y;
    wire upper_Cin;
    wire [7:0] upper_y;

    // Lower 8 bits
    adder_8bit lower_adder(a[7:0], b[7:0], Cin, lower_y, upper_Cin);

    // Upper 8 bits
    adder_8bit upper_adder(a[15:8], b[15:8], upper_Cin, upper_y, Co);

    assign y = {upper_y, lower_y};
endmodule