module full_adder_1bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Co
);
    wire [7:0] carry; // internal carry wires between bits

    // First bit
    full_adder_1bit fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(Cin),
        .sum(y[0]),
        .cout(carry[0])
    );

    // Bits 1 to 6
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : fa_loop
            full_adder_1bit fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(y[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign Co = carry[7];
endmodule

module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire carry_mid;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule