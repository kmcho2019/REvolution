module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Internal signals
reg [8:0] SR; // Shift register
reg [8:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Flag to start the division process
reg [7:0] temp_dividend; // Temporary dividend
reg [7:0] temp_divisor; // Temporary divisor
reg dividend_saved; // Flag to indicate if dividend is saved
reg divisor_saved; // Flag to indicate if divisor is saved

// Capture inputs
always @(posedge clk) begin
    if (rst) begin
        temp_dividend <= 0;
        temp_divisor <= 0;
        dividend_saved <= 0;
        divisor_saved <= 0;
    end else if (opn_valid && !res_valid) begin
        temp_dividend <= dividend;
        temp_divisor <= divisor;
        dividend_saved <= 1;
        divisor_saved <= 1;
    end
end

// Initialize shift register and NEG_DIVISOR
always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
    end else if (dividend_saved && divisor_saved && !start_cnt) begin
        if (sign) begin
            SR <= {1'b0, (temp_dividend[7] ? -temp_dividend : temp_dividend)};
            NEG_DIVISOR <= -({8{1'b0}} - (temp_divisor[7] ? -temp_divisor : temp_divisor));
        end else begin
            SR <= {1'b0, temp_dividend};
            NEG_DIVISOR <= -temp_divisor;
        end
        start_cnt <= 1;
        cnt <= 1;
    end
end

// Division process
always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            result <= {SR[8:1], SR[0:0]};
        end else begin
            if (SR[8] == 0) begin
                SR <= {SR[7:0], 1'b0};
            end else begin
                SR <= {SR[7:0], 1'b1};
            end
            if (SR[8:1] >= NEG_DIVISOR[8:1]) begin
                SR <= {SR[7:0] - NEG_DIVISOR[8:1], 1'b0};
            end else begin
                SR <= {SR[7:0], 1'b1};
            end
            cnt <= cnt + 1;
        end
    end
end

// Result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (cnt == 0 && !start_cnt) begin
        res_valid <= 1;
    end else if (opn_valid && res_valid) begin
        res_valid <= 0;
    end
end

endmodule