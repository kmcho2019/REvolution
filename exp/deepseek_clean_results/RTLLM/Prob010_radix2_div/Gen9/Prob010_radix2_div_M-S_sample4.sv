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

reg [3:0] cnt;          // 0-8 counter
reg [15:0] SR;          // Shift register [remainder|quotient]
reg [7:0] divisor_abs;  // Absolute divisor value
reg div_by_zero;        // Division by zero flag
reg calc_active;        // Calculation in progress

// Combinational logic
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs_wire = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];  // 1 if remainder >= divisor
wire [15:0] next_SR = carry_out ? {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};

// Result assembly
wire [7:0] rem = sign & dividend[7] ? -SR[15:8] : SR[15:8];
wire [7:0] quo = (sign & (dividend[7] ^ divisor[7])) ? -SR[7:0] : SR[7:0];
wire [15:0] final_result = div_by_zero ? 16'hFFFF : {rem, quo};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        div_by_zero <= 0;
        calc_active <= 0;
    end else begin
        if (calc_active) begin
            if (cnt == 8) begin
                result <= final_result;
                res_valid <= 1;
                calc_active <= 0;
            end else begin
                SR <= next_SR;
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            divisor_abs <= divisor_abs_wire;
            div_by_zero <= (divisor == 0);
            SR <= {8'b0, dividend_abs, 1'b0};
            cnt <= 0;
            calc_active <= 1;
            res_valid <= 0;
        end else if (!opn_valid) begin
            res_valid <= 0;  // Clear valid when opn_valid drops
        end
    end
end

endmodule