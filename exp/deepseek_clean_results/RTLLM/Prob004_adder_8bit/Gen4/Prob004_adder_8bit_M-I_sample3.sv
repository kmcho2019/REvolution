module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry;

    // Bit 0 (special case for cin)
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | ((a[0] ^ b[0]) & cin);

    // Bits 1-6 using generate
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | ((a[i] ^ b[i]) & carry[i-1]);
        end
    endgenerate

    // Bit 7 (special case for cout)
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign cout = (a[7] & b[7]) | ((a[7] ^ b[7]) & carry[6]);

endmodule