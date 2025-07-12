// 1-bit full adder module
module full_adder_1bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit ripple carry adder using generate loop
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] c;  // internal carries

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adders
            if (i == 0) begin
                full_adder_1bit fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end else begin
                full_adder_1bit fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(c[i-1]),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end
        end
    endgenerate

    assign cout = c[7];
endmodule