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
reg [7:0] neg_divisor;
reg [7:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg res_valid_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        abs_dividend <= 8'd0;
        abs_divisor <= 8'd0;
        neg_divisor <= 8'd0;
        sr <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid_reg <= 1'd0;
        quotient <= 8'd0;
    end else begin
        if (opn_valid &&!res_valid_reg) begin
            abs_dividend <= (sign)? ({8{dividend[7]}} ^ dividend) + 8'd1 : dividend;
            abs_divisor <= (sign)? ({8{divisor[7]}} ^ divisor) + 8'd1 : divisor;
            neg_divisor <= ~abs_divisor + 8'd1;
            sr <= {1'd0, abs_dividend};
            cnt <= 3'd1;
            start_cnt <= 1'd1;
        end else if (start_cnt) begin
            if (cnt == 8'd8) begin
                start_cnt <= 1'd0;
                cnt <= 3'd0;
                quotient <= sr[7:0];
                if (sign) begin
                    if (dividend[7]!= divisor[7]) begin
                        quotient <= ~quotient + 8'd1;
                    end
                    if (dividend[7]) begin
                        sr[7:0] <= ~sr[7:0] + 8'd1;
                    end
                end
            end else begin
                cnt <= cnt + 3'd1;
                if (sr[8] == 1'd0) begin
                    sr <= {sr[7], sr[8:1]};
                end else begin
                    sr <= {1'd1, sr[8:1]} + {8'd0, neg_divisor};
                end
            end
        end
        if (rst || (cnt == 3'd0 &&!start_cnt)) begin
            res_valid_reg <= 1'd0;
        end else if (cnt == 3'd8) begin
            res_valid_reg <= 1'd1;
        end
    end
end

assign res_valid = res_valid_reg;
assign result = {sr[7:0], quotient};

endmodule