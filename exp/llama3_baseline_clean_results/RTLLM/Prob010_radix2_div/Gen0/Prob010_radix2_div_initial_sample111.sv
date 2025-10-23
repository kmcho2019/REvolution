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
reg [15:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg [7:0] remainder;
reg result_consumed;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result_consumed <= 1'b1;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        sr <= 16'b0;
        neg_divisor <= 8'b0;
    end else if (opn_valid &&!res_valid) begin
        // Operation Start
        abs_dividend <= (sign)? ({8{~dividend[7]}} + dividend) : dividend;
        abs_divisor <= (sign)? ({8{~divisor[7]}} + divisor) : divisor;
        neg_divisor <= ~abs_divisor + 1'b1;
        sr <= {1'b0, abs_dividend};
        start_cnt <= 1'b1;
        cnt <= 3'b001;
        res_valid <= 1'b0;
        result_consumed <= 1'b1;
    end else if (start_cnt) begin
        // Division Process
        if (cnt == 3'b100) begin
            // Division complete
            quotient <= sr[7:0];
            remainder <= sr[15:8];
            result <= {remainder, quotient};
            start_cnt <= 1'b0;
            cnt <= 3'b000;
            res_valid <= 1'b1;
            result_consumed <= 1'b0;
        end else begin
            // Update shift register
            reg [8:0] sub;
            sub <= {1'b0, sr[15:8]} - neg_divisor;
            if (sub[8]) begin
                sr <= {1'b1, sr[15:8]} << 1;
            end else begin
                sr <= {1'b0, sr[15:8] + abs_divisor} << 1;
            end
            cnt <= cnt + 1'b1;
        end
    end else if (res_valid &&!result_consumed) begin
        // Result validity
        res_valid <= 1'b0;
        result_consumed <= 1'b1;
    end
end

assign result = (sign)? {remainder, quotient} : {remainder, quotient};

endmodule