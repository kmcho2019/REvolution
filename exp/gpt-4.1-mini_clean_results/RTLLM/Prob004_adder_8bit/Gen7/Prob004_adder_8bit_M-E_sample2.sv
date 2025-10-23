module full_adder_bit (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Full adder combinational logic
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] c; // internal carry signals
    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : fa_chain
            if (i == 0) begin
                full_adder_bit fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(c[i])
                );
            end else begin
                full_adder_bit fa (
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