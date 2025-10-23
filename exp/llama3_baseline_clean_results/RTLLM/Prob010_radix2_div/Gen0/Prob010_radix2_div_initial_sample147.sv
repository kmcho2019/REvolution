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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [15:0] temp_result;

// Initialize the shift register and other signals
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= sign ? {~dividend[7] + 1, dividend[7:1], dividend[0]} : dividend;
        abs_divisor <= sign ? {~divisor[7] + 1, divisor[7:1], divisor[0]} : divisor;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= {~abs_divisor[7] + 1, abs_divisor[7:1], abs_divisor[0]};
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            res_valid <= 1;
            result <= {SR[15:8], SR[7:0]};
        end else begin
            // Update shift register and counter
            if (SR[15:8] >= NEG_DIVISOR) begin
                SR <= {SR[14:0], 1'b1};
            end else begin
                SR <= {SR[14:0], 1'b0};
            end
            SR <= {SR[7:0] - NEG_DIVISOR, 1'b0} + {8'b00000001, SR[7]};
            cnt <= cnt + 1;
        end
    end
end

// Manage result validity signal
always @(posedge clk) begin
    if (rst || !opn_valid) begin
        res_valid <= 0;
    end else if (start_cnt && cnt == 8) begin
        res_valid <= 1;
    end
end

endmodule