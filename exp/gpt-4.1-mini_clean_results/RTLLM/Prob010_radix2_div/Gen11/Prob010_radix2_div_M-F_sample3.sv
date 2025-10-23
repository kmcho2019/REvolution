module radix2_div (
    input            clk,
    input            rst,
    input            sign,           // 1: signed, 0: unsigned
    input      [7:0] dividend,
    input      [7:0] divisor,
    input            opn_valid,
    output reg       res_valid,
    output     [15:0] result          // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [16:0] SR;           // {remainder[8:0], quotient[7:0]}
    reg [7:0]  dividend_r, divisor_r;
    reg        dividend_neg, divisor_neg;
    reg [7:0]  dividend_mag, divisor_mag;
    reg        running;
    reg [3:0]  count;        // cycle counter 0..8

    // Signed correction registers
    reg [7:0] quotient_corr;
    reg [7:0] remainder_corr;

    // Result register
    reg [15:0] result_reg;
    assign result = result_reg;

    // Extended divisor magnitude for subtraction
    wire [8:0] divisor_ext = {1'b0, divisor_mag};

    // Temporary signals for subtraction and shifting
    reg [16:0] shifted_SR;
    reg [8:0]  sub_res;
    reg        borrow_sub;

    // Sign flags for final correction
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Intermediate variables declared at module scope
    reg [7:0] raw_quotient;
    reg [7:0] raw_remainder;
    reg [16:0] final_SR;

    // Combinational logic for subtraction and shift update
    always @(*) begin
        if (running) begin
            shifted_SR = {SR[15:0], 1'b0};                 // Shift left by 1
            sub_res = shifted_SR[16:8] - divisor_ext;      // Subtract divisor from remainder
            borrow_sub = sub_res[8];                        // borrow_sub = 1 if subtraction negative
        end else begin
            shifted_SR = 17'd0;
            sub_res = 9'd0;
            borrow_sub = 1'b0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR           <= 17'd0;
            dividend_r   <= 8'd0;
            divisor_r    <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            dividend_mag <= 8'd0;
            divisor_mag  <= 8'd0;
            running      <= 1'b0;
            count        <= 4'd0;
            res_valid    <= 1'b0;
            result_reg   <= 16'd0;
            quotient_corr<= 8'd0;
            remainder_corr<=8'd0;
            raw_quotient <= 8'd0;
            raw_remainder<= 8'd0;
            final_SR     <= 17'd0;
        end else begin
            if (!running) begin
                res_valid <= 1'b0;
                if (opn_valid && (divisor != 8'd0)) begin
                    // Latch inputs
                    dividend_r <= dividend;
                    divisor_r  <= divisor;
                    if (sign) begin
                        dividend_neg <= dividend[7];
                        divisor_neg  <= divisor[7];
                        dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                        divisor_mag  <= divisor[7] ? (~divisor + 8'd1)  : divisor;
                    end else begin
                        dividend_neg <= 1'b0;
                        divisor_neg  <= 1'b0;
                        dividend_mag <= dividend;
                        divisor_mag  <= divisor;
                    end
                    // Initialize SR with remainder=0, quotient=dividend_mag
                    SR <= {9'd0, dividend_mag};
                    count <= 4'd0;
                    running <= 1'b1;
                end
            end else begin
                // Perform division iteration
                if (!borrow_sub) begin
                    // Subtraction succeeded: update remainder, set quotient LSB=1
                    SR <= {sub_res, shifted_SR[7:1], 1'b1};
                end else begin
                    // Subtraction failed: restore remainder, set quotient LSB=0
                    SR <= {shifted_SR[16:8], shifted_SR[7:1], 1'b0};
                end

                count <= count + 1'b1;

                if (count == 4'd7) begin
                    // Division done after this iteration
                    running <= 1'b0;

                    // Compute what would be the SR next after current operation
                    if (!borrow_sub)
                        final_SR = {sub_res, shifted_SR[7:1], 1'b1};
                    else
                        final_SR = {shifted_SR[16:8], shifted_SR[7:1], 1'b0};

                    raw_quotient <= final_SR[7:0];
                    raw_remainder <= final_SR[16:9];

                    // Apply sign corrections
                    quotient_corr <= quotient_neg ? (~final_SR[7:0] + 8'd1) : final_SR[7:0];
                    remainder_corr <= remainder_neg ? (~final_SR[16:9] + 8'd1) : final_SR[16:9];

                    // Output result
                    result_reg <= {remainder_corr, quotient_corr};
                    res_valid <= 1'b1;
                end
            end

            // Clear res_valid when new operation requested and not running
            if (res_valid && opn_valid && !running)
                res_valid <= 1'b0;
        end
    end

endmodule