module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] c; // carry wires between adders

    // First bit adder: carry-in is cin input
    full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c[0])
    );

    // Bits 1 through 6
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : bit_adders
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i-1]),
                .sum(sum[i]),
                .cout(c[i])
            );
        end
    endgenerate

    // Final carry-out
    assign cout = c[7];

endmodule