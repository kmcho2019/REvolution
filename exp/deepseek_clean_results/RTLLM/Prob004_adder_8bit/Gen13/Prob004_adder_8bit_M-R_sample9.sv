module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry chain between bit adders
    wire [8:0] carry;
    assign carry[0] = cin;

    // Generate sum and carry for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_loop
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] | b[i]));
        end
    endgenerate

    assign cout = carry[8];

endmodule