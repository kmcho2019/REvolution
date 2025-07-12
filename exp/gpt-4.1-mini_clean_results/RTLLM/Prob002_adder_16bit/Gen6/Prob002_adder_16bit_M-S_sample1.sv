module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] carry;

    assign carry[0] = Cin;
    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : ripple_adder
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            if (i < 7)
                assign carry[i+1] = (a[i] & b[i]) | ((a[i] ^ b[i]) & carry[i]);
        end
    endgenerate
    assign Co = (a[7] & b[7]) | ((a[7] ^ b[7]) & carry[7]);
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule