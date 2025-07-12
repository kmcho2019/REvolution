module TopModule (
    input  wire       do_sub,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output reg  [7:0] out,
    output reg        result_is_zero
);

    reg [7:0] b_xor;
    reg [7:0] sum;
    reg [7:0] carry;
    integer i;

    always @(*) begin
        // Step 1: Conditionally invert b for subtraction (two’s complement)
        for (i = 0; i < 8; i = i + 1) begin
            b_xor[i] = b[i] ^ do_sub;
        end

        // Step 2: Initialize carry-in with do_sub (0 for add, 1 for subtract)
        carry[0] = do_sub;

        // Step 3: Ripple carry adder logic for sum and carry propagation
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            if (i < 7)
                carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end

        // Step 4: Assign outputs
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR: 1 if sum is zero, else 0
    end

endmodule