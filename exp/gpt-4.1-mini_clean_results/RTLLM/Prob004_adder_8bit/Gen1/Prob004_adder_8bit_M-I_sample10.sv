module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;

    // Bit 0
    assign {carry[0], sum[0]} = a[0] + b[0] + cin;

    // Bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : bit_adders
            assign {carry[i], sum[i]} = a[i] + b[i] + carry[i-1];
        end
    endgenerate

    assign cout = carry[7];
endmodule