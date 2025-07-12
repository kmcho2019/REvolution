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

reg [15:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [2:0] cnt; // counter
reg start_cnt; // start counter
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor
reg [7:0] quotient; // quotient
reg [7:0] remainder; // remainder
reg res_valid_reg; // registered result validity

assign res_valid = res_valid_reg;

always @(posedge clk) begin
    if (rst) begin
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
        res_valid_reg <= 1'b0;
    end else if (opn_valid && !res_valid_reg) begin
        abs_dividend <= (sign) ? ({8{dividend[7]}} ^ dividend) + (dividend[7] ? 8'd1 : 8'd0) : dividend;
        abs_divisor <= (sign) ? ({8{divisor[7]}} ^ divisor) + (divisor[7] ? 8'd1 : 8'd0) : divisor;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= ~(abs_divisor);
        cnt <= 3'd1;
        start_cnt <= 1'b1;
        res_valid_reg <= 1'b0;
    end else if (start_cnt) begin
        if (cnt == 3'd8) begin
            remainder <= SR[15:8];
            quotient <= SR[7:0];
            if (sign && (dividend[7] != divisor[7])) begin
                quotient <= ~quotient + 1'b1;
            end
            if (sign && (dividend[7] == 1'b1) && (quotient == 8'd0)) begin
                remainder <= ~remainder + 1'b1;
            end
            result <= {remainder, quotient};
            res_valid_reg <= 1'b1;
            cnt <= 3'd0;
            start_cnt <= 1'b0;
        end else begin
            if (SR[15] == 1'b0) begin
                SR <= {SR[14:0], 1'b0};
            end else begin
                SR <= SR + NEG_DIVISOR;
                SR <= {SR[14:0], SR[15]};
            end
            cnt <= cnt + 1'b1;
        end
    end
end

endmodule