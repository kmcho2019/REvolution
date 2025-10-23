// Full adder module defined separately
module full_adder (
    input  wire x,
    input  wire y,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);
endmodule

// 8-bit adder using a generate loop for full adders
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry; // internal carries between full adders

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : adder_bits
            if (i == 0) begin
                // First full adder takes cin input
                full_adder fa(
                    .x   (a[i]),
                    .y   (b[i]),
                    .cin (cin),
                    .sum (sum[i]),
                    .cout(carry[i])
                );
            end else begin
                // Subsequent full adders take carry from previous bit
                full_adder fa(
                    .x   (a[i]),
                    .y   (b[i]),
                    .cin (carry[i-1]),
                    .sum (sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[7];

endmodule