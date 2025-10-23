module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Packed carry signals array (index 0 unused for cleaner indexing)
    wire [8:0] carry;
    assign carry[0] = cin;

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] | b[i]));
        end
    endgenerate

    // Final carry out
    assign cout = carry[8];

endmodule