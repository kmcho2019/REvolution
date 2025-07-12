module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry = {cout, sum};
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = a[i] & b[i] | carry[i] & (a[i] | b[i]);
        end
    endgenerate

endmodule