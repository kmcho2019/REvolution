module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] c;

    assign c[0] = cin;
    assign sum[0] = a[0] ^ b[0] ^ c[0];
    assign c[1] = (a[0] & b[0]) | (a[0] & c[0]) | (b[0] & c[0]);

    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            assign c[i] = (a[i-1] & b[i-1]) | (a[i-1] & c[i-1]) | (b[i-1] & c[i-1]);
        end
    endgenerate

    assign cout = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);

endmodule