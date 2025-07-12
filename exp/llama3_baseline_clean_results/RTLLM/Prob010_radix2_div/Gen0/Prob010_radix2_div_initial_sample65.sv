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

reg [7:0] sr; // shift register
reg [7:0] neg_divisor; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg start_cnt; // start counter flag
reg [15:0] result_reg; // result register

// initialize result and res_valid on reset
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result_reg <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end
    else if (opn_valid && !res_valid) begin
        // initialize inputs
        if (sign) begin
            // signed division
            sr <= ({1'b0, (dividend[7] ? -dividend : dividend)} << 1);
            neg_divisor <= ({1'b0, (divisor[7] ? -divisor : divisor)});
        end
        else begin
            // unsigned division
            sr <= (dividend << 1);
            neg_divisor <= (~divisor + 1);
        end
        cnt <= 1;
        start_cnt <= 1;
    end
    else if (start_cnt) begin
        // perform division
        if (cnt == 8) begin
            // division complete
            cnt <= 0;
            start_cnt <= 0;
            result_reg <= {sr[7:0], sr[7:0]};
            res_valid <= 1;
        end
        else begin
            // update shift register
            reg [8:0] temp;
            temp <= sr - neg_divisor;
            if (temp[8]) begin
                // no borrow
                sr <= (sr << 1);
            end
            else begin
                // borrow
                sr <= ((sr - neg_divisor) << 1);
            end
            cnt <= cnt + 1;
        end
    end
    else if (res_valid) begin
        // result consumed
        res_valid <= 0;
    end
end

assign result = result_reg;

endmodule