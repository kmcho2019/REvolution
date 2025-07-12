module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] carry;

    // First bit with input carry
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);

    // Middle 6 bits
    genvar i;
    generate
        for (i = 1; i < 7; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Last bit with output carry
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign cout = (a[7] & b[7]) | (a[7] & carry[6]) | (b[7] & carry[6]);

endmodule