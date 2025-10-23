module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry; // 9-bit carry chain (cin + 8 bits + cout)

    // Initialize carry chain
    assign carry[0] = cin;

    // Explicit implementation for bit 0 (potential optimization point)
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);

    // Generate remaining bits (1-7) for scalability
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : adder_chain
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    // Final carry out
    assign cout = carry[8];

endmodule