module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] b_xor;          // Conditioned operand B (XOR with do_sub)
    reg [8:0] carry;          // Carry chain, 9 bits to hold carry out of MSB
    reg [7:0] sum;            // Sum bits

    integer i;

    always @(*) begin
        // Conditional inversion of b for subtraction
        b_xor = b ^ {8{do_sub}};

        // Initialize carry-in to do_sub (0 for add, 1 for subtract)
        carry[0] = do_sub;

        // Ripple carry addition
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end

        out = sum;
        result_is_zero = ~|sum;  // Zero flag: reduction NOR of sum
    end

endmodule