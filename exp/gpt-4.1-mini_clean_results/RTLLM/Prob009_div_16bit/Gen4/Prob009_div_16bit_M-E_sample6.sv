module div_16bit(
    input  [15:0] A,          // 16-bit dividend
    input  [7:0]  B,          // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    integer i;

    // Always block 1: latch inputs for stable operation
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Always block 2: combinational division algorithm
    always @(*) begin
        reg [23:0] remainder_shift; // 16 bits dividend shifted left 8 + 8 bits for remainder
        reg [15:0] quotient_tmp;
        reg [7:0]  rem_segment;

        quotient_tmp = 16'd0;
        remainder_shift = {a_reg, 8'd0}; // Place dividend in upper bits, remainder bits zero

        // Iterate over each bit (MSB to LSB) of dividend
        // Total 16 iterations to extract quotient bits
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder_shift left by 1 (shift in next dividend bit automatically)
            remainder_shift = remainder_shift << 1;

            // Extract top 8 bits as current remainder segment
            rem_segment = remainder_shift[23:16];

            // Compare remainder segment with divisor b_reg
            if (rem_segment >= b_reg && b_reg != 0) begin
                // Subtract divisor from remainder segment
                rem_segment = rem_segment - b_reg;

                // Set quotient bit i to 1
                quotient_tmp[i] = 1'b1;

                // Update remainder_shift with new remainder segment
                remainder_shift[23:16] = rem_segment;
            end else begin
                quotient_tmp[i] = 1'b0;
                // remainder_shift unchanged except for shift
            end
        end

        // Assign outputs
        result = quotient_tmp;
        // The remainder is in the top 8 bits of remainder_shift (bits 23:16)
        // Extend to 16 bits by placing remainder in lower 8 bits (upper 8 zero)
        odd = {8'd0, remainder_shift[23:16]};
    end

endmodule