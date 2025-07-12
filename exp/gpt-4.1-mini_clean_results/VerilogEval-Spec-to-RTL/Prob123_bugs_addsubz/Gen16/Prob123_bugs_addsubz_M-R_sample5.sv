module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    wire [7:0] b_xor;            // Conditionally inverted B for subtraction
    wire [8:0] carry;            // Carry chain with 9 bits
    wire [7:0] sum;              // Sum bits

    assign b_xor = b ^ {8{do_sub}};  // XOR B with do_sub to select add/subtract
    assign carry[0] = do_sub;         // Initial carry-in: 0 for add, 1 for subtract

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            // Sum bit: a XOR b_xor XOR carry-in
            assign sum[i] = a[i] ^ b_xor[i] ^ carry[i];

            // Carry-out: majority function of a[i], b_xor[i], carry[i]
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    always @(*) begin
        out = sum;
        result_is_zero = ~|sum;   // Reduction NOR to detect zero result
    end

endmodule