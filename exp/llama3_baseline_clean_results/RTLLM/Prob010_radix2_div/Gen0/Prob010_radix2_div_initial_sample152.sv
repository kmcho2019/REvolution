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

reg [7:0] neg_divisor;
reg [15:0] shift_register;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg res_valid_reg;

always @(posedge clk) begin
    if (rst) begin
        res_valid_reg <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 4'd0;
        shift_register <= 16'd0;
        neg_divisor <= 8'd0;
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
    end else if (opn_valid && !res_valid_reg) begin
        dividend_reg <= sign ? {{8{dividend[7]}} , dividend} : {8'd0, dividend};
        divisor_reg <= sign ? {{8{divisor[7]}} , divisor} : {8'd0, divisor};
        neg_divisor <= ~divisor_reg + 1;
        shift_register <= {1'b0, dividend_reg};
        cnt <= 4'd1;
        start_cnt <= 1'b1;
        res_valid_reg <= 1'b0;
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            start_cnt <= 1'b0;
            cnt <= 4'd0;
            result <= {shift_register[15:8], shift_register[7:0]};
            res_valid_reg <= 1'b1;
        end else begin
            if (shift_register[15] == 1'b0) begin
                shift_register <= {shift_register[14:0], 1'b0};
            end else begin
                shift_register <= (shift_register + neg_divisor)[15:0];
                shift_register[0] <= shift_register[15];
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg) begin
        res_valid_reg <= 1'b0;
    end
end

assign res_valid = res_valid_reg;

endmodule