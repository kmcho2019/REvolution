module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] p;     // propagate signals
    wire [7:0] g;     // generate signals
    wire [7:0] carry; // internal carry wires

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign p[i] = a[i] ^ b[i];
            assign g[i] = a[i] & b[i];
            if (i == 0) begin
                assign carry[i] = g[i] | (p[i] & cin);
                assign sum[i] = p[i] ^ cin;
            end else begin
                assign carry[i] = g[i] | (p[i] & carry[i-1]);
                assign sum[i] = p[i] ^ carry[i-1];
            end
        end
    endgenerate

    assign cout = carry[7];

endmodule