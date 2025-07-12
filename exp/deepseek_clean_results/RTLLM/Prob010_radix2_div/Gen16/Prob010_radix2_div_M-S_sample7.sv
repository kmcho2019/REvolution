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
reg [15:0] SR;  // {remainder, quotient}
reg [7:0] divisor_reg;
reg running;
reg quotient_sign;
reg divide_by_zero;

// Absolute values
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction result
wire [8:0] sub_result = {SR[15:8]} - divisor_reg;
wire sub_ok = ~sub_result[8];  // remainder >= divisor if no borrow

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
        running <= 0;
    end else begin
        res_valid <= 0;
        
        if (opn_valid && !running && !res_valid) begin
            // Start new division
            divide_by_zero <= (divisor == 0);
            quotient_sign <= sign & (dividend[7] ^ divisor[7]);
            SR <= {8'b0, dividend_abs};
            divisor_reg <= divisor_abs;
            cnt <= 0;
            running <= 1;
        end
        
        if (running) begin
            if (divide_by_zero) begin
                // Handle divide by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1;
                running <= 0;
            end else if (cnt == 8) begin
                // Final result
                result[15:8] <= (sign & dividend[7]) ? -SR[15:8] : SR[15:8];
                result[7:0] <= quotient_sign ? -SR[7:0] : SR[7:0];
                res_valid <= 1;
                running <= 0;
            end else begin
                // Division step
                SR <= sub_ok ? 
                    {sub_result[7:0], SR[7:0], 1'b1} : 
                    {SR[14:0], 1'b0};
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule