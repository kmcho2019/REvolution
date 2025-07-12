module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Stage 0: Register inputs combinationally
    reg [15:0] a_reg;
    reg [7:0]  b_reg;
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Internal signals for the two-stage division
    wire [7:0] high_dividend = a_reg[15:8];
    wire [7:0] low_dividend  = a_reg[7:0];

    // Outputs of first stage division: quotient and remainder
    wire [7:0] q_high;
    wire [7:0] r_high;

    // Outputs of second stage division: quotient and remainder
    wire [7:0] q_low;
    wire [7:0] r_low;

    // --------- 8-bit combinational divider --------------
    // This module divides 8-bit dividend by 8-bit divisor combinationally
    // Using shift-subtract iterative approach

    function automatic [15:0] div8_comb;
        input [15:0] div_input; // {dividend, divisor} packed
        reg   [7:0] dividend_f;
        reg   [7:0] divisor_f;
        reg   [8:0] remainder_f; // 9 bits for carry
        reg   [7:0] quotient_f;
        integer i;
        begin
            dividend_f = div_input[15:8];
            divisor_f  = div_input[7:0];
            remainder_f = 9'd0;
            quotient_f = 8'd0;
            for (i=7; i>=0; i=i-1) begin
                remainder_f = {remainder_f[7:0], dividend_f[i]};
                if (remainder_f >= {1'b0, divisor_f}) begin
                    remainder_f = remainder_f - {1'b0, divisor_f};
                    quotient_f[i] = 1'b1;
                end else begin
                    quotient_f[i] = 1'b0;
                end
            end
            div8_comb = {quotient_f, remainder_f[7:0]};
        end
    endfunction

    // Perform first division: high_dividend / b_reg
    wire [15:0] div1_res;
    assign div1_res = div8_comb({high_dividend, b_reg});
    assign q_high = div1_res[15:8];
    assign r_high = div1_res[7:0];

    // Prepare second dividend: concatenate r_high and low_dividend (16 bits)
    wire [15:0] second_dividend = {r_high, low_dividend};

    // Perform second division: second_dividend / b_reg
    wire [15:0] div2_res;
    assign div2_res = div8_comb({second_dividend[15:8], b_reg});
    assign q_low = div2_res[15:8];
    assign r_low = div2_res[7:0];

    // --------- Combine outputs ---------
    always @(*) begin
        result = {q_high, q_low};
        odd = {8'b0, r_low};
    end

endmodule