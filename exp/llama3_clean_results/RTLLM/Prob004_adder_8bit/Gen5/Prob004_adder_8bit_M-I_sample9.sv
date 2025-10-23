module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input   cin,
    output  [7:0] sum,
    output  cout
);
    wire [7:0] g; // Generate signals
    wire [7:0] p; // Propagate signals
    wire [7:0] c; // Carry signals

    // Use a generate loop to create instances for bits 0 to 7
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                assign g[i] = a[i] & b[i];
                assign p[i] = a[i] ^ b[i];
                assign c[i] = g[i] | (p[i] & cin);
            end else begin
                assign g[i] = a[i] & b[i];
                assign p[i] = a[i] ^ b[i];
                assign c[i] = g[i] | (p[i] & c[i-1]);
            end
        end
    endgenerate

    // Use a generate loop to create instances for bits 0 to 7
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                assign sum[i] = p[i] ^ cin;
            end else begin
                assign sum[i] = p[i] ^ c[i-1];
            end
        end
    endgenerate

    // Carry-out of the most significant bit is the final carry-out
    assign cout = g[7] | (p[7] & c[6]);
endmodule