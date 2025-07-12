module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;

    // First bit
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));

    // Bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : bit_adder
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (carry[i-1] & (a[i] ^ b[i]));
        end
    endgenerate

    assign cout = carry[7];

endmodule