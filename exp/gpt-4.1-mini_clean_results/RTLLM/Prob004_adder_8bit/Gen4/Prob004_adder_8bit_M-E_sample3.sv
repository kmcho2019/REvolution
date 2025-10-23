module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] carry; // carry[0] = cin, carry[8] = final cout

    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adders
            // sum[i] = a[i] ^ b[i] ^ carry[i]
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            // carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i])
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign cout = carry[8];
endmodule