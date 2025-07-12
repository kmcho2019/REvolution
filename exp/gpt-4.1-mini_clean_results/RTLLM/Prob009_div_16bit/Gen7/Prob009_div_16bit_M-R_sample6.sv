module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    integer i;
    reg [8:0] rem;    // 9-bit remainder register to hold intermediate values
    reg [15:0] quot;  // 16-bit quotient register

    always @(*) begin
        rem = 9'd0;
        quot = 16'd0;

        // Iterate through each bit of dividend from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            rem = {rem[7:0], A[i]};

            // Compare remainder and divisor (extended with 1 zero bit)
            if (rem >= {1'b0, B}) begin
                rem = rem - {1'b0, B};
                quot[i] = 1'b1;
            end else begin
                quot[i] = 1'b0;
            end
        end

        result = quot;
        // Zero-extend remainder to 16 bits, remainder valid in lower 8 bits
        odd = {8'd0, rem[7:0]};
    end

endmodule