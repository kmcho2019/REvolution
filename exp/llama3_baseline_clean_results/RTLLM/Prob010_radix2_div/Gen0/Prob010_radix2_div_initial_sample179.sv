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

// Internal signals and registers
reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter signal
reg [7:0] dividend_reg; // Registered dividend
reg [7:0] divisor_reg; // Registered divisor
reg sign_reg; // Registered sign

// Operation start
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sign_reg <= 1'd0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sign_reg <= sign;
        SR <= {1'd0, dividend_reg};
        if (sign_reg) begin
            NEG_DIVISOR <= ~(-divisor_reg) + 1'd1;
        end else begin
            NEG_DIVISOR <= ~(-divisor_reg);
        end
        cnt <= 3'd1;
        start_cnt <= 1'd1;
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 3'd8) begin
            cnt <= 3'd0;
            start_cnt <= 1'd0;
            result <= {SR[7:0], SR[7:0]};
        end else begin
            if (SR[7:0] >= divisor_reg) begin
                SR <= {1'd1, SR[7:0]} - {divisor_reg, 1'd0};
            end else begin
                SR <= {1'd0, SR[7:0]} - {divisor_reg, 1'd0};
            end
            cnt <= cnt + 1'd1;
        end
    end
end

// Result validity
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'd0;
    end else if (cnt == 3'd0 && start_cnt == 1'd0) begin
        res_valid <= 1'd1;
    end else if (opn_valid && !res_valid) begin
        res_valid <= 1'd0;
    end
end

endmodule