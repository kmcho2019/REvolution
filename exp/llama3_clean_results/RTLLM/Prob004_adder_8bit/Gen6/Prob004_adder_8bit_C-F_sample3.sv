module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    wire [7:0] g; // Generate signals
    wire [7:0] p; // Propagate signals
    wire [7:0] c; // Carry signals

    // Calculate generate and propagate signals for bit 0
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];

    // Use a generate loop to create instances for bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
        end
    endgenerate

    // Calculate carry signals using carry-lookahead approach
    assign c[0] = g[0] | (p[0] & cin);
    generate
        for (i = 1; i < 8; i++) begin
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Calculate sum signals using XOR operation
    assign sum[0] = a[0] ^ b[0] ^ cin;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ c[i-1];
        end
    endgenerate

    // Carry-out of the most significant bit is the final carry-out
    assign cout = g[7] | (p[7] & c[6]);
endmodule