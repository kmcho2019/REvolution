module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] b_xor;
    reg [7:0] sum;
    reg [7:0] carry;

    integer i;

    always @(*) begin
        // Step 1: Conditionally invert b bits for subtraction (two's complement)
        for (i = 0; i < 8; i = i + 1) begin
            b_xor[i] = b[i] ^ do_sub;
        end

        // Step 2: Initialize carry-in as do_sub for add/subtract selection
        carry[0] = do_sub;

        // Step 3: Ripple carry addition logic per bit
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            if (i < 7) begin
                carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
            end
        end

        // Step 4: Assign outputs
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR for zero detection
    end

endmodule