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

reg [7:0] dividend_reg;  
reg [7:0] divisor_reg;  
reg [7:0] remainder;  
reg [7:0] quotient;  
reg [3:0] cnt;  

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        remainder <= 8'd0;
        quotient <= 8'd0;
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= (sign && dividend[7])? (~dividend + 1) : dividend;
        divisor_reg <= (sign && divisor[7])? (~divisor + 1) : divisor;
        remainder <= {1'b0, dividend_reg};
        quotient <= 8'd0;
        cnt <= 4'd1;
        res_valid <= 1'b0;
    end else if (res_valid) begin
        res_valid <= 1'b0;
    end else if (cnt < 4'd8) begin
        if (remainder >= {1'b0, divisor_reg}) begin
            remainder <= remainder - {1'b0, divisor_reg};
            quotient <= quotient + (1 << (cnt - 1));
        end
        remainder <= {remainder[6:0], 1'b0};
        cnt <= cnt + 1;
    end else begin
        result <= {remainder, quotient};
        res_valid <= 1'b1;
    end
end

endmodule