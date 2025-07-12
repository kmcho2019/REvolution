module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;      // B XORed with do_sub for inversion in subtraction
    wire [8:0] carry;      // Carry chain: 9 bits for carry-in and 8 outputs
    wire [7:0] sum;

    genvar i;

    // Conditional inversion of b: b_xor = b ^ do_sub
    assign b_xor = b ^ {8{do_sub}};

    // Initial carry-in is do_sub for two's complement subtraction; carry[0] is input carry
    assign carry[0] = do_sub;

    // Generate block to compute sum and carry bits combinationally
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    // Combinational logic to assign outputs
    always @(*) begin
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR for zero detection
    end

endmodule