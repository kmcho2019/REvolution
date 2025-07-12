module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain with one extra bit for final carry out
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Bit-level adder implementation
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            // Sum calculation (XOR of inputs and carry)
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Optimized carry calculation:
            // carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]))
            // This form reduces gate count while maintaining same functionality
            assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
        end
    endgenerate

    // Final carry out
    assign cout = carry[WIDTH];

endmodule