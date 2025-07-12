module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    wire [7:0] c;

    assign c[0] = a[0] & b[0] | (a[0] & cin) | (b[0] & cin);
    assign sum[0] = a[0] ^ b[0] ^ cin;

    generate
        for (genvar i = 1; i < 8; i++) begin
            assign c[i] = a[i] & b[i] | (a[i] & c[i-1]) | (b[i] & c[i-1]);
            assign sum[i] = a[i] ^ b[i] ^ c[i-1];
        end
    endgenerate

    assign cout = a[7] & b[7] | (a[7] & c[6]) | (b[7] & c[6]);

endmodule