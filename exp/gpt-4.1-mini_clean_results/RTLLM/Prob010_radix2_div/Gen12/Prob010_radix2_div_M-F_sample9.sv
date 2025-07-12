module radix2_div (
    input            clk,
    input            rst,
    input            sign,           // 1: signed operation, 0: unsigned
    input      [7:0] dividend,       // Dividend input
    input      [7:0] divisor,        // Divisor input
    input            opn_valid,      // Operation start request, active high
    output reg       res_valid,      // Result valid output, active high
    output reg [15:0] result         // {remainder[7:0], quotient[7:0]}
);

    // Internal registers
    reg [16:0] SR;        // Shift register {remainder[8:0], quotient[7:0]}
    reg [7:0]  divisor_mag;
    reg [7:0]  dividend_mag;
    reg        dividend_neg;
    reg        divisor_neg;
    reg [3:0]  count;
    reg        running;

    wire [8:0] remainder = SR[16:8];
    wire [7:0] quotient  = SR[7:0];

    wire [8:0] divisor_ext = {1'b0, divisor_mag};
    wire [8:0] sub_res = remainder - divisor_ext;
    wire       borrow = sub_res[8];

    // Compute next SR for one step of division:
    // If subtraction result borrow=0 (no borrow), remainder updated with sub_res and quotient LSB set to 1
    // Else remainder remains and quotient LSB set to 0
    wire [16:0] SR_next = {borrow ? remainder : sub_res[7:0], quotient[6:0], borrow ? 1'b0 : 1'b1};

    // Sign-correct quotient and remainder after division
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    wire [7:0] quotient_final = quotient_neg ? (~quotient + 8'd1) : quotient;
    wire [7:0] remainder_final = remainder_neg ? (~remainder[7:0] + 8'd1) : remainder[7:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid    <= 1'b0;
            SR           <= 17'd0;
            divisor_mag  <= 8'd0;
            dividend_mag <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            count        <= 4'd0;
            running      <= 1'b0;
            result       <= 16'd0;
        end else begin
            // Start division operation on opn_valid rising edge when not running and no result valid
            if (!running && opn_valid && !res_valid) begin
                // Latch and convert inputs to magnitude if signed
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    dividend_mag <= dividend[7] ? (~dividend + 8'd1) : dividend;
                    divisor_mag  <= divisor[7] ? (~divisor + 8'd1) : divisor;
                end else begin
                    dividend_neg <= 1'b0;
                    divisor_neg  <= 1'b0;
                    dividend_mag <= dividend;
                    divisor_mag  <= divisor;
                end
                count   <= 4'd0;
                running <= 1'b1;
                res_valid <= 1'b0;
                // Initialize shift register: remainder = 0 (9 bits), quotient = dividend_mag (8 bits)
                SR <= {9'd0, dividend_mag};
            end else if (running) begin
                if (count == 4'd8) begin
                    // Division finished after 8 iterations
                    running <= 1'b0;
                    res_valid <= 1'b1;
                    // Output sign-corrected remainder and quotient
                    result <= {remainder_final, quotient_final};
                end else begin
                    // Perform one division iteration step
                    SR <= SR_next;
                    count <= count + 1'b1;
                end
            end else if (res_valid && !opn_valid) begin
                // Clear res_valid once operation is accepted/consumed (opn_valid deasserted)
                res_valid <= 1'b0;
            end
        end
    end

endmodule