module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [15:0] sr;  // shift register
reg [3:0] cnt;  // counter
reg [7:0] divisor_reg;  // registered divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        divisor_reg <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid &&!res_valid) begin
            if (sign) begin
                // Signed division
                sr <= {8'd0, (dividend[7]? ~dividend + 1 : dividend)};
                divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
            end else begin
                // Unsigned division
                sr <= {8'd0, dividend};
                divisor_reg <= divisor;
            end
            cnt <= 1;
        end else if (cnt < 8) begin
            reg [7:0] temp;
            temp <= sr[15:8] - divisor_reg;
            if (temp[7]) begin
                // Borrow
                sr <= {sr[15:8] + divisor_reg, sr[7:0], 1'b0};
            end else begin
                // No borrow
                sr <= {temp, sr[7:0], 1'b1};
            end
            cnt <= cnt + 1;
        end else if (res_valid == 0) begin
            result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
        end
    end
end

endmodule