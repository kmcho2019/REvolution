module radix2_div (
    input             clk,
    input             rst,
    input             sign,
    input      [7:0]  dividend,
    input      [7:0]  divisor,
    input             opn_valid,
    output reg        res_valid,
    output reg [15:0] result
);

    reg [3:0] cnt;              // division step counter
    reg       running;          // flag indicating division in progress

    reg [8:0] SR;               // shift register: [8:1] remainder, [0] quotient bit shifted in each step
    reg [8:0] neg_divisor;      // two's complement negative divisor

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    reg       dividend_neg;
    reg       divisor_neg;

    wire [8:0] sub_res;
    wire       sub_cout;

    // Subtraction: SR[8:1] + neg_divisor (neg_divisor is negative of abs_divisor)
    assign {sub_cout, sub_res} = {1'b0, SR[8:1]} + neg_divisor;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt          <= 0;
            running      <= 0;
            SR           <= 0;
            neg_divisor  <= 0;
            abs_dividend <= 0;
            abs_divisor  <= 0;
            dividend_neg <= 0;
            divisor_neg  <= 0;
            res_valid    <= 0;
            result       <= 0;
        end else begin
            if (!running && opn_valid && !res_valid) begin
                // Capture inputs and calculate absolute values
                if (sign) begin
                    dividend_neg <= dividend[7];
                    divisor_neg  <= divisor[7];
                    abs_dividend <= dividend[7] ? (~dividend + 1) : dividend;
                    abs_divisor  <= divisor[7] ? (~divisor + 1) : divisor;
                end else begin
                    dividend_neg <= 0;
                    divisor_neg  <= 0;
                    abs_dividend <= dividend;
                    abs_divisor  <= divisor;
                end

                SR          <= {abs_dividend, 1'b0};                      // Load dividend shifted left by 1
                neg_divisor <= {1'b0, (~abs_divisor + 1'b1)};            // Negative divisor for subtraction
                cnt         <= 1;
                running     <= 1;
                res_valid   <= 0;
                result      <= 0;
            end else if (running) begin
                // Perform division step
                if (cnt == 8) begin
                    // Last cycle - update SR according to subtraction result
                    if (sub_cout)
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    else
                        SR <= {SR[7:0], SR[0], 1'b0};

                    running <= 0;
                    cnt     <= 0;

                    // Prepare to output result with sign correction next cycle
                end else begin
                    if (sub_cout)
                        SR <= {sub_res[7:0], SR[0], 1'b1};
                    else
                        SR <= {SR[7:0], SR[0], 1'b0};
                    cnt <= cnt + 1;
                end
            end else if (!running && !res_valid && (cnt == 0) && (SR != 0)) begin
                // After finishing division, apply sign correction and output result

                reg [7:0] quotient;
                reg [7:0] remainder;

                quotient  = SR[7:0];
                remainder = SR[8:1];

                if (sign) begin
                    if (dividend_neg ^ divisor_neg)
                        quotient = ~quotient + 1;
                    if (dividend_neg)
                        remainder = ~remainder + 1;
                end

                result    <= {remainder, quotient};
                res_valid <= 1;

                // Clear SR to prevent re-output
                SR <= 0;
            end else if (res_valid) begin
                // Clear res_valid after result is consumed (opn_valid low)
                if (!opn_valid)
                    res_valid <= 0;
            end
        end
    end

endmodule