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

reg [15:0] shift_register;
reg [3:0] cnt;
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg neg_divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_register <= 0;
        cnt <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            abs_dividend <= (sign && dividend[7])? ~dividend + 1 : dividend;
            abs_divisor <= (sign && divisor[7])? ~divisor + 1 : divisor;
            neg_divisor <= (sign && divisor[7]);
            shift_register <= {8'd0, abs_dividend};
            cnt <= 1;
        end

        if (cnt > 0 && cnt < 9) begin
            reg [8:0] temp;
            temp <= {1'b0, shift_register[15:8]} - {1'b0, abs_divisor};
            if (temp[8]) begin
                shift_register <= {shift_register[15:8], shift_register[7:0], 1'b0};
            end else begin
                shift_register <= {temp[7:0], shift_register[7:0], 1'b1};
            end
            cnt <= cnt + 1;
        end

        if (cnt == 9) begin
            if (sign && (dividend[7] != divisor[7])) begin
                result <= {(~shift_register[15:8] + 1), (~shift_register[7:0] + 1)};
            end else begin
                result <= {shift_register[15:8], shift_register[7:0]};
            end
            res_valid <= 1;
        end

        if (res_valid) begin
            if (!opn_valid) begin
                res_valid <= 0;
                cnt <= 0;
            end
        end
    end
end

endmodule