module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    wire [7:0] carry;

    assign carry[0] = cin;
    assign sum[0] = a[0] ^ b[0] ^ carry[0];

    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate

    assign cout = carry[7];

endmodule