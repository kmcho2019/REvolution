module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            // sum = a ^ b ^ cin
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            // cout = majority of (a, b, cin)
            assign carry[i+1] = (a[i] & b[i]) | (b[i] & carry[i]) | (a[i] & carry[i]);
        end
    endgenerate

    assign cout = carry[8];
endmodule