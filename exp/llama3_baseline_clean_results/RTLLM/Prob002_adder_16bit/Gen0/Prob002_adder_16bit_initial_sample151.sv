module adder_1bit(a, b, Cin, y, Co);
    input a, b, Cin;
    output y, Co;

    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a, b;
    input Cin;
    output [7:0] y;
    output Co;

    wire [6:0] carry;

    adder_1bit bit0(.a(a[0]),.b(b[0]),.Cin(Cin),.y(y[0]),.Co(carry[0]));
    generate
        for (genvar i = 1; i < 8; i++) begin
            adder_1bit bit(.a(a[i]),.b(b[i]),.Cin(carry[i-1]),.y(y[i]),.Co(carry[i]));
        end
    endgenerate
    assign Co = carry[7];
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a, b;
    input Cin;
    output [15:0] y;
    output Co;

    wire carry8;

    adder_8bit lower8(.a(a[7:0]),.b(b[7:0]),.Cin(Cin),.y(y[7:0]),.Co(carry8));
    adder_8bit upper8(.a(a[15:8]),.b(b[15:8]),.Cin(carry8),.y(y[15:8]),.Co(Co));
endmodule