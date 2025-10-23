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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [8:0] NEG_DIVISOR;
reg [9:0] SR;
reg [2:0] cnt;
reg start_cnt;
reg prev_res_valid;

// Absolute values of inputs
always @(posedge clk) begin
    if(rst) begin
        abs_dividend <= 0;
        abs_divisor <= 0;
    end else if(opn_valid && !res_valid) begin
        if(sign) begin
            abs_dividend <= (dividend[7] == 1) ? (~dividend + 1) : dividend;
            abs_divisor <= (divisor[7] == 1) ? (~divisor + 1) : divisor;
        end else begin
            abs_dividend <= dividend;
            abs_divisor <= divisor;
        end
    end
end

// Initialize NEG_DIVISOR and SR
always @(posedge clk) begin
    if(rst) begin
        NEG_DIVISOR <= 0;
        SR <= 0;
    end else if(opn_valid && !res_valid) begin
        NEG_DIVISOR <= (~abs_divisor + 1);
        SR <= {1'b0, abs_dividend};
    end
end

// Counter and start_cnt
always @(posedge clk) begin
    if(rst) begin
        cnt <= 0;
        start_cnt <= 0;
    end else if(opn_valid && !res_valid) begin
        cnt <= 1;
        start_cnt <= 1;
    end else if(start_cnt) begin
        if(cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Division process
always @(posedge clk) begin
    if(start_cnt) begin
        reg [9:0] temp_SR;
        reg [9:0] subtraction;
        subtraction <= SR - NEG_DIVISOR;
        temp_SR <= (subtraction[9] == 1) ? (SR << 1) : (subtraction << 1);
        SR <= temp_SR;
    end
end

// Result validity
always @(posedge clk) begin
    if(rst) begin
        res_valid <= 0;
    end else if(opn_valid && !res_valid) begin
        prev_res_valid <= 0;
    end else if(start_cnt && cnt == 8) begin
        prev_res_valid <= 1;
        res_valid <= 1;
    end else if(res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

// Final result
always @(posedge clk) begin
    if(rst) begin
        result <= 0;
    end else if(res_valid && !prev_res_valid) begin
        result <= {SR[9:1], SR[0]};
    end
end

endmodule