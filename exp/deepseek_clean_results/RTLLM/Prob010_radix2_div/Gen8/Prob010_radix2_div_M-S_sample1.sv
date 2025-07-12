module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [3:0] cnt;
reg [15:0] SR;  // [remainder|quotient]
reg [7:0] divisor_neg;
reg calculating;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        calculating <= 0;
        result <= 0;
    end else begin
        if (opn_valid && !calculating && !res_valid) begin
            // Start new division
            SR <= {8'b0, dividend_abs};
            divisor_neg <= -divisor_abs;
            cnt <= 0;
            calculating <= 1;
            res_valid <= 0;
        end else if (calculating) begin
            // Division step
            if (cnt < 8) begin
                // Perform subtraction and shift
                if (SR[15:8] >= divisor_abs) begin
                    SR <= {SR[15:8] + divisor_neg, SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end else begin
                // Division complete
                calculating <= 0;
                res_valid <= 1;
                // Handle sign correction
                if (divisor == 0) begin
                    result <= {8'hFF, 8'hFF}; // Divide by zero
                end else begin
                    result <= {
                        (sign & dividend[7]) ? -SR[15:8] : SR[15:8],  // remainder
                        ((sign & dividend[7]) ^ (sign & divisor[7])) ? -SR[7:0] : SR[7:0]  // quotient
                    };
                end
            end
        end else if (res_valid && opn_valid) begin
            // Ready for new operation
            res_valid <= 0;
        end
    end
end

endmodule