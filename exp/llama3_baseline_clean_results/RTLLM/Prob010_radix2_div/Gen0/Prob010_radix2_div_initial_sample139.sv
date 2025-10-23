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

reg [7:0] NEG_DIVISOR;
reg [7:0] SR_QUOTIENT;
reg [7:0] SR_REMAINDER;
reg [7:0] shift_register;
reg [2:0] cnt;
reg start_cnt;
reg internal_res_valid;
reg signed [7:0] signed_dividend;
reg signed [7:0] signed_divisor;

always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        internal_res_valid <= 0;
        SR_QUOTIENT <= 0;
        SR_REMAINDER <= 0;
        shift_register <= 0;
        NEG_DIVISOR <= 0;
    end
    else if (opn_valid && !internal_res_valid) begin
        if (sign) begin
            signed_dividend <= dividend;
            signed_divisor <= divisor;
            if (signed_dividend[7]) begin
                SR_REMAINDER <= ~(-signed_dividend) + 1;
            end
            else begin
                SR_REMAINDER <= signed_dividend;
            end
            if (signed_divisor[7]) begin
                NEG_DIVISOR <= ~(-signed_divisor) + 1;
            end
            else begin
                NEG_DIVISOR <= signed_divisor;
            end
        end
        else begin
            SR_REMAINDER <= {1'b0, dividend};
            NEG_DIVISOR <= {8{~divisor[7]}};
        end
        cnt <= 1;
        start_cnt <= 1;
    end
    else if (start_cnt) begin
        if (cnt == 8) begin
            start_cnt <= 0;
            cnt <= 0;
            internal_res_valid <= 1;
            SR_QUOTIENT <= shift_register[7:0];
            SR_REMAINDER <= shift_register[15:8];
        end
        else begin
            reg [8:0] subtraction_result;
            subtraction_result <= {1'b0, SR_REMAINDER} - NEG_DIVISOR;
            if (subtraction_result[8]) begin
                shift_register <= {SR_REMAINDER[7:0], 1'b0};
            end
            else begin
                shift_register <= {SR_REMAINDER[7:0], 1'b1};
            end
            SR_REMAINDER <= subtraction_result[7:0];
            cnt <= cnt + 1;
        end
    end
    else if (internal_res_valid && !opn_valid) begin
        internal_res_valid <= 0;
    end
end

assign result = {SR_REMAINDER, SR_QUOTIENT};
assign res_valid = internal_res_valid;

endmodule