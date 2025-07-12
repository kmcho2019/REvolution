module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;
    assign carry[0] = (a[0] & b[0]) | ((a[0] ^ b[0]) & cin);
    assign sum[0] = a[0] ^ b[0] ^ cin;

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : add_bits
            assign carry[i] = (a[i] & b[i]) | ((a[i] ^ b[i]) & carry[i-1]);
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate

    assign cout = carry[7];
endmodule