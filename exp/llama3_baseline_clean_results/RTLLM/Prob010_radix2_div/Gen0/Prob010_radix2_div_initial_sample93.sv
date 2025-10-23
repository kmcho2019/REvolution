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

reg [7:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Start counter signal
reg [15:0] temp_result;  // Temporary result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 8'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize shift register and counter
        if (sign) begin
            // Signed division
            sr <= {1'b0, dividend[7] ? ~dividend + 1 : dividend};
            neg_divisor <= divisor[7] ? ~divisor + 1 : divisor;
        end else begin
            // Unsigned division
            sr <= {1'b0, dividend};
            neg_divisor <= divisor;
        end
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 3'b0;
            start_cnt <= 1'b0;
            temp_result <= {sr[15:8], sr[7:0]};
        end else begin
            // Update shift register and counter
            reg [8:0] subtract_result;
            subtract_result <= sr[15:8] - neg_divisor;
            sr <= {subtract_result[8], (subtract_result[8] ? sr[7:0] : {1'b1, sr[7:1]})};
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (!rst) begin
        res_valid <= start_cnt && (cnt == 8);
        if (res_valid) begin
            result <= temp_result;
        end
    end
end

endmodule