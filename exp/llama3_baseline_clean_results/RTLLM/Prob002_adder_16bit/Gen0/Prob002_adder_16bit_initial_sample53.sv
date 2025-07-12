// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;
    assign carry[0] = Cin;
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] & b[7]) | (a[7] & carry[7]) | (b[7] & carry[7]);

    // Generate full adder for each bit
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry[i] = (a[i-1] & b[i-1]) | (a[i-1] & carry[i-1]) | (b[i-1] & carry[i-1]);
            assign y[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate

endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire Cmid;
    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Cmid)
    );

    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Cmid),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule