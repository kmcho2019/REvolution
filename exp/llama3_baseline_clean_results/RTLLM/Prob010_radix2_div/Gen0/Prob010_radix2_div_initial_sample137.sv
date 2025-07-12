module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [15:0] SR; // Shift register to hold the dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the division steps
reg start_cnt; // Flag to indicate the start of the division process
reg [7:0] dividend_reg; // Registered dividend
reg [7:0] divisor_reg; // Registered divisor
reg res_valid_reg; // Registered res_valid signal
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        res_valid_reg <= 1'b0;
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        quotient <= 8'd0;
        remainder <= 8'd0;
    end else if (opn_valid &&!res_valid_reg) begin
        // Save inputs and initialize registers
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (sign) begin
            // Signed division
            SR <= {1'b0, abs(dividend_reg)} << 1;
            NEG_DIVISOR <= ~abs(divisor_reg) + 1;
        end else begin
            // Unsigned division
            SR <= {1'b0, dividend_reg} << 1;
            NEG_DIVISOR <= ~divisor_reg + 1;
        end
        cnt <= 3'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 8'd8) begin
            // Division complete
            start_cnt <= 1'b0;
            cnt <= 3'd0;
            remainder <= SR[15:8];
            quotient <= SR[7:0];
            res_valid_reg <= 1'b1;
        end else begin
            // Update shift register and counter
            reg [8:0] sub_result;
            sub_result <= SR[15:8] - NEG_DIVISOR;
            if (sub_result[8]) begin
                // Carry-out, select 0
                SR <= {1'b0, SR[15:8]} << 1;
            end else begin
                // No carry-out, select 1
                SR <= {1'b1, SR[15:8]} << 1;
            end
            SR[7:0] <= sub_result[7:0];
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg) begin
        // Result valid, clear res_valid_reg when consumed
        if (!opn_valid) begin
            res_valid_reg <= 1'b0;
        end
    end
end

assign res_valid = res_valid_reg;
assign result = {remainder, quotient};

// Function to calculate absolute value
function [7:0] abs;
input [7:0] a;
begin
    if (a[7]) begin
        abs = ~a + 1;
    end else begin
        abs = a;
    end
end
endfunction

endmodule