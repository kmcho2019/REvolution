module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    // Division function returning quotient and remainder
    function automatic [23:0] divide; // {remainder[7:0], quotient[15:0]}
        input [15:0] dividend;
        input [7:0] divisor;
        integer i;
        reg [7:0] remainder_local;
        reg [15:0] quotient_local;
    begin
        remainder_local = 8'd0;
        quotient_local = 16'd0;

        // Handle division by zero
        if (divisor == 8'd0) begin
            quotient_local = 16'd0;
            remainder_local = 8'd0;
        end else begin
            // Long division: iterate from MSB to LSB of dividend
            for (i = 15; i >= 0; i = i - 1) begin
                // Shift remainder left by 1 and input current dividend bit
                remainder_local = {remainder_local[6:0], dividend[i]};
                if (remainder_local >= divisor) begin
                    remainder_local = remainder_local - divisor;
                    quotient_local[i] = 1'b1;
                end else begin
                    quotient_local[i] = 1'b0;
                end
            end
        end

        // Pack remainder and quotient together for returning
        divide = {remainder_local, quotient_local};
    end
    endfunction

    always @(*) begin
        reg [23:0] div_result;
        div_result = divide(A, B);
        // Extract quotient and remainder
        result = div_result[15:0];
        odd    = {8'd0, div_result[23:16]}; // zero-extend remainder to 16 bits
    end

endmodule