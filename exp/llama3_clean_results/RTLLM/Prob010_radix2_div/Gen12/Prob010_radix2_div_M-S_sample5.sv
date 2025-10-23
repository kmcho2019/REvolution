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

reg [15:0] shift_reg;  
reg [7:0] neg_divisor;  
reg [3:0] cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        shift_reg <= 0;
        neg_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            shift_reg <= sign ? {{8{dividend[7]}}, dividend} : {8'b0, dividend};
            neg_divisor <= ~divisor + 1;
            cnt <= 1;
        end else if (cnt <= 7) begin
            cnt <= cnt + 1;
            if (shift_reg[15:8] >= divisor) begin
                shift_reg <= {shift_reg[15:8] - divisor, 1'b1, shift_reg[7:1]};
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
        end else if (cnt > 7) begin
            result <= {shift_reg[15:8], shift_reg[7:0]};
            res_valid <= 1;
            cnt <= 0;
        end else if (!opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule