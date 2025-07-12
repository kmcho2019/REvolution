module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry;

    // Instantiate 8 full adders in a generate loop
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : add_bit
            if (i == 0) begin
                full_adder fa (.a(a[i]), .b(b[i]), .cin(cin), .sum(sum[i]), .cout(carry[i]));
            end else begin
                full_adder fa (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(sum[i]), .cout(carry[i]));
            end
        end
    endgenerate

    assign cout = carry[7];

endmodule