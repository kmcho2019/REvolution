module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] g;  // Generate signal
    wire [7:0] p;  // Propagate signal
    wire [7:0] c;  // Carry signal

    // Calculate generate and propagate signals
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] | b[i];
        end
    endgenerate

    // Calculate carry signals using carry-lookahead approach
    assign c[0] = g[0] | (p[0] & cin);
    genvar j;
    generate
        for (j = 1; j < 8; j++) begin
            assign c[j] = g[j] | (p[j] & c[j-1]);
        end
    endgenerate

    // Calculate sum using XOR operation
    genvar k;
    generate
        for (k = 0; k < 8; k++) begin
            assign sum[k] = a[k] ^ b[k] ^ (k == 0 ? cin : c[k-1]);
        end
    endgenerate

    // Calculate carry-out
    assign cout = g[7] | (p[7] & c[6]);

endmodule