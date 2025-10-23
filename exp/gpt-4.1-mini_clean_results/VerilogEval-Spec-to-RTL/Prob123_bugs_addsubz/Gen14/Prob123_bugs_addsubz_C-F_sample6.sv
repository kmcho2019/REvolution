module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] b_xor;          // Conditioned operand B (XOR with do_sub)
    reg [8:0] carry;          // Carry chain: carry[0] = do_sub
    reg [7:0] sum;            // Sum bits

    integer i;

    always @(*) begin
        // Prepare operand B for addition or subtraction
        b_xor = b ^ {8{do_sub}};

        // Initial carry-in set to do_sub to support addition (0) or subtraction (1)
        carry[0] = do_sub;

        // Ripple carry adder-subtractor
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end

        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR: 1 if sum is zero, else 0
    end

endmodule