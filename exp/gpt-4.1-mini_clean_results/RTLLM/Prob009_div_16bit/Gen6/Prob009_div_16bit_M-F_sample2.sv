module div_16bit(
    input  [15:0] A,          // 16-bit dividend
    input  [7:0]  B,          // 8-bit divisor
    output reg [15:0] result, // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder (upper 8 bits zero)
);

    integer i;
    reg [23:0] working;       // Holds remainder in bits [23:16] and dividend bits in [15:0]
    reg [15:0] quotient_tmp;

    always @(*) begin
        quotient_tmp = 16'd0;
        // Initialize working register:
        // Place dividend in lower 16 bits, remainder in upper 8 bits = 0 initially
        // The top 8 bits [23:16] act as remainder register
        // So initialize remainder as 0 and dividend in [15:0]
        working = {8'd0, A};

        // Perform 16 steps
        for (i = 15; i >= 0; i = i - 1) begin
            // Compare remainder part [23:16] with divisor B
            if (B != 0 && working[23:16] >= B) begin
                // Subtract divisor from remainder part
                working[23:16] = working[23:16] - B;
                // Set current quotient bit to 1
                quotient_tmp[i] = 1'b1;
            end else begin
                // quotient bit 0 if subtraction not possible
                quotient_tmp[i] = 1'b0;
            end
            // Shift working register left by 1 to bring next dividend bit into remainder
            working = working << 1;
        end

        result = quotient_tmp;
        // After 16 shifts, remainder is in upper 8 bits [23:16]
        // Output remainder zero-extended to 16 bits
        odd = {8'd0, working[23:16]};
    end

endmodule