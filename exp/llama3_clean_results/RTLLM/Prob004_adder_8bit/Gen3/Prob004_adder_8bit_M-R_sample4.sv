module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] p, g, c;

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 0) begin
                assign p[i] = a[i] ^ b[i];
                assign g[i] = a[i] & b[i];
                assign sum[i] = p[i] ^ c[i];
                assign c[i+1] = g[i] | (p[i] & c[i]);
            end else if (i < 7) begin
                assign p[i] = a[i] ^ b[i];
                assign g[i] = a[i] & b[i];
                assign sum[i] = p[i] ^ c[i];
                assign c[i+1] = g[i] | (p[i] & c[i]);
            end else begin
                assign p[i] = a[i] ^ b[i];
                assign g[i] = a[i] & b[i];
                assign sum[i] = p[i] ^ c[i];
                assign cout = g[i] | (p[i] & c[i]);
            end
        end
    endgenerate

endmodule