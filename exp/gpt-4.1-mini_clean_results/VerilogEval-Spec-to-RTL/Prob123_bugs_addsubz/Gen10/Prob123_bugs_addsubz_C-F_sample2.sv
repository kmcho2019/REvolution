module TopModule #(
    parameter WIDTH = 8
)(
    input  wire                  do_sub,
    input  wire [WIDTH-1:0]      a,
    input  wire [WIDTH-1:0]      b,
    output wire [WIDTH-1:0]      out,
    output wire                  result_is_zero
);

    wire [WIDTH-1:0] b_xor;
    wire [WIDTH-1:0] sum;
    wire [WIDTH:0]   carry;

    // Conditionally invert B bits for subtraction
    assign b_xor = b ^ {WIDTH{do_sub}};

    // Initialize carry-in to do_sub to add the +1 in two's complement subtraction
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : FULL_ADDER_BITS
            // sum bit: XOR of a, b_xor, and carry-in
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            // carry-out: majority function of a, b_xor, carry-in
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    // Assign final outputs
    assign out = sum;
    assign result_is_zero = ~|sum;  // reduction NOR to detect zero result

endmodule