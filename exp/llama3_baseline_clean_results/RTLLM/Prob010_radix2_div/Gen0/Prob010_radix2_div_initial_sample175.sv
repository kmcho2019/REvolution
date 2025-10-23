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

reg [7:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg start_cnt; // start counter flag
reg [7:0] abs_dividend; // absolute value of dividend
reg [7:0] abs_divisor; // absolute value of divisor

always @(*) begin
    if (sign) begin
        abs_dividend = (dividend[7] == 1'b0) ? dividend : (~dividend + 1'b1);
        abs_divisor = (divisor[7] == 1'b0) ? divisor : (~divisor + 1'b1);
    end else begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        SR <= {1'b0, abs_dividend}; // initialize shift register
        NEG_DIVISOR <= (~abs_divisor) + 1'b1; // set NEG_DIVISOR
        cnt <= 4'd1; // set counter to 1
        start_cnt <= 1'b1; // set start counter flag
    end else if (start_cnt) begin
        if (cnt == 4'd8) begin
            // division complete, update result
            if (sign && (dividend[7] != divisor[7])) begin
                result <= {~SR[7:0] + 1'b1, ~SR[15:8] + 1'b1}; // signed result
            end else begin
                result <= {SR[7:0], SR[15:8]}; // unsigned result
            end
            res_valid <= 1'b1; // set result valid flag
            cnt <= 4'd0; // clear counter
            start_cnt <= 1'b0; // clear start counter flag
        end else begin
            // perform division
            reg [8:0] sub_result;
            sub_result = {1'b0, SR[15:8]} - NEG_DIVISOR;
            SR <= {sub_result[8], SR[15:1]}; // update shift register
            cnt <= cnt + 4'd1; // increment counter
        end
    end else if (res_valid) begin
        res_valid <= 1'b0; // clear result valid flag
    end
end

endmodule