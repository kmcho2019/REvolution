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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] remainder;
reg [7:0] quotient;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        remainder <= 0;
        quotient <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Save inputs and initialize variables
        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'd0, dividend[7:0]};
        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : {8'd0, divisor[7:0]};
        neg_divisor <= ~divisor_reg + 1;
        sr <= {1'b0, dividend_reg};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            remainder <= sr[15:8];
            quotient <= sr[7:0];
            res_valid <= 1;
        end else begin
            // Update shift register and counter
            reg [16:0] sub_result;
            sub_result <= sr - neg_divisor;
            sr <= {sub_result[16], sr[15:1]};
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid) begin
        // Reset result validity
        res_valid <= 0;
    end
end

assign result = {remainder, quotient};

endmodule