module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input   cin,
    output  [7:0] sum,
    output  cout
);
    wire [7:1] c; // Carry signals (excluding the first bit)

    // Use a single generate loop to create instances for bits 0 to 7
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                assign sum[i] = a[i] ^ b[i] ^ cin;
                assign c[i] = (a[i] & b[i]) | (a[i] & cin) | (b[i] & cin);
            end else begin
                assign sum[i] = a[i] ^ b[i] ^ c[i-1];
                assign c[i] = (a[i] & b[i]) | (a[i] & c[i-1]) | (b[i] & c[i-1]);
            end
        end
    endgenerate

    // Carry-out of the most significant bit is the final carry-out
    assign cout = c[7];
endmodule