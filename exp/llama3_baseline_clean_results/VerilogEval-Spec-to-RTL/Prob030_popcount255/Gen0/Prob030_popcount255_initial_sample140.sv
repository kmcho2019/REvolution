module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [127:0] count_2;
    wire [63:0] count_4;
    wire [31:0] count_8;
    wire [15:0] count_16;
    wire [7:0] count_32;
    wire [3:0] count_64;
    wire [1:0] count_128;
    wire [0:0] count_255;

    // Counting 1's in groups of 2
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            half_adder ha0(
                .a(in[i*2]),
                .b(in[i*2+1]),
                .sum(count_2[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 4
    generate
        for (i = 0; i < 64; i++) begin
            full_adder fa1(
                .a(count_2[i*2]),
                .b(count_2[i*2+1]),
                .cin(0),
                .sum(count_4[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 8
    generate
        for (i = 0; i < 32; i++) begin
            full_adder fa2(
                .a(count_4[i*2]),
                .b(count_4[i*2+1]),
                .cin(0),
                .sum(count_8[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 16
    generate
        for (i = 0; i < 16; i++) begin
            full_adder fa3(
                .a(count_8[i*2]),
                .b(count_8[i*2+1]),
                .cin(0),
                .sum(count_16[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 32
    generate
        for (i = 0; i < 8; i++) begin
            full_adder fa4(
                .a(count_16[i*2]),
                .b(count_16[i*2+1]),
                .cin(0),
                .sum(count_32[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 64
    generate
        for (i = 0; i < 4; i++) begin
            full_adder fa5(
                .a(count_32[i*2]),
                .b(count_32[i*2+1]),
                .cin(0),
                .sum(count_64[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 128
    generate
        for (i = 0; i < 2; i++) begin
            full_adder fa6(
                .a(count_64[i*2]),
                .b(count_64[i*2+1]),
                .cin(0),
                .sum(count_128[i]),
                .cout()
            );
        end
    endgenerate

    // Counting 1's in groups of 255
    full_adder fa7(
        .a(count_128[0]),
        .b(count_128[1]),
        .cin(0),
        .sum(count_255[0]),
        .cout()
    );

    // Assign the final count
    assign out = count_255[0];

endmodule

// Half adder module
module half_adder(
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule