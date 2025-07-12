module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [7:0] c;

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            if (i == 7) begin
                assign sum[i] = a[i] ^ b[i] ^ c[i];
                assign cout = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
            end else begin
                assign sum[i] = a[i] ^ b[i] ^ c[i];
                assign c[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
            end
        end
    endgenerate

endmodule