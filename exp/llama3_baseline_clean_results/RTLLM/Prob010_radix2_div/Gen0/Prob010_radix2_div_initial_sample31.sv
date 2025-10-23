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

reg [7:0] sr;  // shift register
reg [7:0] neg_divisor;  // negated absolute value of the divisor
reg [2:0] cnt;  // counter
reg start_cnt;  // start counter signal
reg [15:0] temp_result;  // temporary result
reg temp_res_valid;  // temporary result validity signal

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        temp_result <= 0;
        temp_res_valid <= 0;
        res_valid <= 0;
    end else begin
        // operation start
        if (opn_valid && !res_valid) begin
            sr <= {1'b0, (sign) ? (~dividend + 1) : dividend};
            neg_divisor <= (sign) ? (~divisor + 1) : divisor;
            cnt <= 1;
            start_cnt <= 1;
        end
        
        // division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // division complete
                cnt <= 0;
                start_cnt <= 0;
                temp_result <= {sr[7:0], sr[7:0]};
                temp_res_valid <= 1;
            end else begin
                // update shift register
                reg [8:0] temp_sr;
                temp_sr <= sr - {neg_divisor, 1'b0};
                if (temp_sr[8]) begin
                    sr <= {1'b0, sr[7:0]} | {8{1'b0}};
                end else begin
                    sr <= {1'b1, sr[7:0]};
                end
                cnt <= cnt + 1;
            end
        end
        
        // result validity
        if (rst || !opn_valid) begin
            res_valid <= 0;
        end else if (temp_res_valid) begin
            res_valid <= 1;
            result <= temp_result;
        end
    end
end

endmodule