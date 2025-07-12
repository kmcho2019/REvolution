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
        // Step 1: Conditionally invert B using vector XOR with do_sub
        b_xor = b ^ {8{do_sub}};

        // Step 2: Initialize carry-in with do_sub (0 for add, 1 for subtract)
        carry[0] = do_sub;

        // Step 3: Ripple carry adder logic for each bit
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b_xor[i] ^ carry[i];
            if (i < 7)
                carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end

        // Step 4: Assign outputs
        out = sum;
        result_is_zero = ~|sum;  // Reduction NOR to detect zero output
    end

endmodule