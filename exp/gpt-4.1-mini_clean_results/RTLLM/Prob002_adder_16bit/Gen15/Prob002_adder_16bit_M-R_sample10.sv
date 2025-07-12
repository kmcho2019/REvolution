module full_adder (
    input  wire a,
    input  wire b,
    input  wire Cin,
    output wire sum,
    output wire Cout
);
    // Sum and carry-out implemented combinationally
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (b & Cin) | (a & Cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Co
);
    wire [7:0] carry;

    genvar i;
    generate
        // Instantiate 8 full adders in a ripple carry chain
        for (i = 0; i < 8; i = i + 1) begin : full_adders
            if (i == 0) begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(Cin),
                    .sum(y[i]),
                    .Cout(carry[i])
                );
            end else begin
                full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .Cin(carry[i-1]),
                    .sum(y[i]),
                    .Cout(carry[i])
                );
            end
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
    wire c1;
    wire [7:0] sum_low, sum_high;

    // Lower 8-bit adder
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c1)
    );

    // Upper 8-bit adder
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule