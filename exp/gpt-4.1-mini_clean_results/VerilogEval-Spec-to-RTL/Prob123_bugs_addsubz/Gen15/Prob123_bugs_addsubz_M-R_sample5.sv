module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output wire [7:0]  out,
    output wire        result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] carry;  // 9 bits: carry[0] is initial carry-in
    wire [7:0] sum;

    assign b_xor = b ^ {8{do_sub}};   // conditional invert B
    assign carry[0] = do_sub;          // initial carry-in is do_sub

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            // Full adder logic for each bit
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    assign out = sum;
    assign result_is_zero = ~|sum;  // reduction NOR to detect zero result

endmodule