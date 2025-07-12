module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;           // Conditioned B bits (inverted if do_sub=1)
    wire [8:0] carry;           // Carry signals from bit 0 up to bit 8
    wire [7:0] sum;             // Sum bits

    // Conditional inversion of b for subtraction
    assign b_xor = b ^ {8{do_sub}};

    // Initialize carry-in with do_sub to add +1 for subtraction
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bit
            // sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];

            if (i < 7) begin
                // carry[i+1] = majority(a[i], b_xor[i], carry[i])
                assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
            end
        end
    endgenerate

    // Last carry out (carry[8]) is not used here, but assign it to prevent undriven warning
    assign carry[8] = 1'b0;

    always @(*) begin
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR to detect zero output
    end

endmodule