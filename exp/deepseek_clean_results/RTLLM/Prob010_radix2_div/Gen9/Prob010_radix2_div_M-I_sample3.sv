module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg error,          // New error output
    output reg [15:0] result
);

reg [3:0] state;  // 0: idle, 1-8: calculating, 9: done
reg [15:0] SR;    // [remainder|quotient]
reg [8:0] divisor_neg;  // 9-bit for proper negation

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;
wire [8:0] dividend_ext = {1'b0, dividend_abs};
wire [8:0] divisor_ext = {1'b0, divisor_abs};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        SR <= 0;
        res_valid <= 0;
        error <= 0;
        result <= 0;
    end else begin
        if (opn_valid && (state == 0) && !res_valid) begin
            // Start new division
            if (divisor == 0) begin
                // Handle divide by zero immediately
                state <= 0;
                res_valid <= 1;
                error <= 1;
                result <= {8'hFF, 8'hFF};
            end else begin
                SR <= {8'b0, dividend_abs};
                divisor_neg <= -divisor_ext;  // Proper 9-bit negation
                state <= 1;
                res_valid <= 0;
                error <= 0;
            end
        end else if (state > 0 && state < 9) begin
            // Division step
            if (SR[15:8] >= divisor_abs) begin
                SR <= {SR[15:8] + divisor_neg[7:0], SR[7:0], 1'b1};
            end else begin
                SR <= {SR[14:0], 1'b0};
            end
            state <= state + 1;
        end else if (state == 9) begin
            // Division complete
            state <= 0;
            res_valid <= 1;
            error <= 0;
            // Handle sign correction
            result <= {
                (sign & dividend[7]) ? -SR[15:8] : SR[15:8],  // remainder
                ((sign & dividend[7]) ^ (sign & divisor[7])) ? -SR[7:0] : SR[7:0]  // quotient
            };
        end else if (res_valid && opn_valid) begin
            // Ready for new operation
            res_valid <= 0;
        end
    end
end

endmodule