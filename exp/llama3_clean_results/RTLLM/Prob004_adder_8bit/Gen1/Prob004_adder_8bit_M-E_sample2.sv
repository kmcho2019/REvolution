module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Level 1: Bitwise adders
wire [7:0] partial_sum;
wire [7:0] partial_carry;

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        bitwise_adder #(1) ba(
            .a(a[i]),
            .b(b[i]),
            .cin(cin),
            .sum(partial_sum[i]),
            .cout(partial_carry[i])
        );
    end
endgenerate

// Level 2: Combine partial sums and carries
wire [7:0] combined_sum;
wire [7:0] combined_carry;

genvar j;
generate
    for (j = 0; j < 8; j++) begin
        if (j == 0) begin
            assign combined_sum[j] = partial_sum[j];
            assign combined_carry[j] = partial_carry[j];
        end else begin
            bitwise_adder #(1) ba(
                .a(partial_sum[j]),
                .b(combined_carry[j-1]),
                .cin(1'b0),
                .sum(combined_sum[j]),
                .cout(combined_carry[j])
            );
        end
    end
endgenerate

// Final stage: Combine combined sums and carries
assign sum = combined_sum;
assign cout = combined_carry[7];

endmodule

module bitwise_adder #(
    parameter WIDTH = 1
)(
    input   [WIDTH-1:0] a,
    input   [WIDTH-1:0] b,
    input       cin,
    output  [WIDTH-1:0] sum,
    output      cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule