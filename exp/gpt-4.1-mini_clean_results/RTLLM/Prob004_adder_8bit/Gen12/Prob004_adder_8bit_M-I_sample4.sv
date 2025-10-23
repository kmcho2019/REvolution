module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] carry;

    assign carry[0] = (a[0] & b[0]) | ((a[0] ^ b[0]) & cin);
    assign sum[0]   = a[0] ^ b[0] ^ cin;

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : bit_add
            wire axb = a[i] ^ b[i];
            assign sum[i]   = axb ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (axb & carry[i-1]);
        end
    endgenerate

    assign cout = carry[7];
endmodule