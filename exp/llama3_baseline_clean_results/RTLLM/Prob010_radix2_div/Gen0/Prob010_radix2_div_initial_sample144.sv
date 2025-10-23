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

reg [7:0] sr_dividend;
reg [7:0] sr_divisor;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;
reg res_valid_reg;

assign res_valid = res_valid_reg;
assign result = result_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        sr_dividend <= 0;
        sr_divisor <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
        result_reg <= 0;
    end else if(opn_valid && !res_valid_reg) begin
        // Save inputs and initialize SR
        sr_dividend <= {1'b0, dividend};
        if(sign) begin
            sr_divisor <= ~divisor + 1;
            neg_divisor <= divisor;
        end else begin
            sr_divisor <= divisor;
            neg_divisor <= ~divisor + 1;
        end
        cnt <= 1;
        start_cnt <= 1;
    end else if(start_cnt) begin
        // Perform division process
        if(cnt == 8) begin
            // Division complete, update result and reset
            result_reg <= {sr_dividend[7:0], sr_dividend[15:8]};
            cnt <= 0;
            start_cnt <= 0;
            res_valid_reg <= 1;
        end else begin
            // Compute subtraction
            reg [8:0] sub;
            if(sign) begin
                sub <= {1'b0, sr_dividend[15:8]} - neg_divisor;
            end else begin
                sub <= {1'b0, sr_dividend[15:8]} - sr_divisor;
            end
            // Update SR based on carry-out
            if(sub[8]) begin
                sr_dividend <= {1'b1, sr_dividend[15:1]};
            end else begin
                sr_dividend <= {1'b0, sr_dividend[15:1]} + {8'b0, sub[7:0]};
            end
            cnt <= cnt + 1;
        end
    end else if(res_valid_reg && !opn_valid) begin
        // Reset res_valid when result is consumed
        res_valid_reg <= 0;
    end
end

endmodule