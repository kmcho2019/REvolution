module multi_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] product
);

    // Generate all partial products with operand isolation
    wire [15:0] pp [0:7];
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? pp[0] << 1 : 16'b0;
    assign pp[2] = B[2] ? pp[1] << 1 : 16'b0;
    assign pp[3] = B[3] ? pp[2] << 1 : 16'b0;
    assign pp[4] = B[4] ? pp[3] << 1 : 16'b0;
    assign pp[5] = B[5] ? pp[4] << 1 : 16'b0;
    assign pp[6] = B[6] ? pp[5] << 1 : 16'b0;
    assign pp[7] = B[7] ? pp[6] << 1 : 16'b0;

    // First level CSA: 4:2 compression
    wire [15:0] sum1, carry1;
    assign {carry1, sum1} = pp[0] + pp[1] + pp[2] + pp[3];

    // Second level CSA: 4:2 compression
    wire [15:0] sum2, carry2;
    assign {carry2, sum2} = pp[4] + pp[5] + pp[6] + pp[7];

    // Final CPA with carry injection
    wire [15:0] intermediate_sum = sum1 + sum2;
    wire [15:0] intermediate_carry = (carry1 << 1) + (carry2 << 1);
    assign product = intermediate_sum + intermediate_carry;

endmodule