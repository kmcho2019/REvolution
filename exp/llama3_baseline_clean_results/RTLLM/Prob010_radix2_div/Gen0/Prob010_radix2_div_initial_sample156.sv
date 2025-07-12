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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [8:0] sr; // shift register
reg [8:0] neg_divisor;
reg [2:0] cnt; // counter
reg start_cnt;
reg [7:0] quotient;
reg [7:0] remainder;

always @ (posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
    end else if (opn_valid &&!res_valid) begin
        // save inputs
        abs_dividend <= sign? { {7{dividend[7]}}, dividend[7:0] } : dividend;
        abs_divisor <= sign? { {7{divisor[7]}}, divisor[7:0] } : divisor;
        // initialize shift register with absolute value of dividend shifted left
        sr <= { 1'b0, abs_dividend };
        // set NEG_DIVISOR to the negated absolute value of the divisor
        neg_divisor <= ~abs_divisor + 1'b1;
        // set counter to 1 and start_cnt to 1
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // division complete, update result
            quotient <= sr[7:0];
            remainder <= sr[15:8];
            res_valid <= 1;
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            // compute subtraction
            reg [8:0] sub;
            sub <= sr + neg_divisor;
            // update shift register based on carry-out
            if (sub[8]) begin
                sr <= { 1'b1, sr[15:1] };
            end else begin
                sr <= { 1'b0, sr[15:1] };
            end
            // increment counter
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid) begin
        res_valid <= 0;
    end
end

assign result = { remainder, quotient };

endmodule