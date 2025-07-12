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
reg [7:0] neg_divisor;
reg [8:0] sr;
reg [2:0] cnt;
reg start_cnt;
reg prev_opn_valid;

wire [8:0] sub_result;
wire carry_out;

assign sub_result = {1'b0, abs_divisor} - {1'b0, sr[7:0]};
assign carry_out = sub_result[8];

always @(*) begin
    if (~sign) begin
        abs_dividend = dividend;
        abs_divisor = divisor;
    end else begin
        abs_dividend = (~dividend + 1'b1);
        abs_divisor = (~divisor + 1'b1);
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 3'b000;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        prev_opn_valid <= 1'b0;
        sr <= 9'b0;
    end else begin
        if (opn_valid && ~prev_opn_valid && ~res_valid) begin
            sr <= {1'b0, abs_dividend};
            neg_divisor <= (~abs_divisor + 1'b1);
            cnt <= 3'b001;
            start_cnt <= 1'b1;
            prev_opn_valid <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 3'b111) begin
                start_cnt <= 1'b0;
                cnt <= 3'b000;
                res_valid <= 1'b1;
                if (~sign) begin
                    result <= {sr[8:1], sr[0:7]};
                end else begin
                    if (dividend[7] == 1'b1) begin
                        result <= {(~sr[8:1] + 1'b1), (~sr[0:7] + 1'b1)};
                    end else begin
                        result <= {sr[8:1], sr[0:7]};
                    end
                end
            end else begin
                if (carry_out == 1'b0) begin
                    sr <= {1'b0, sr[7:0]} + {1'b0, neg_divisor};
                end else begin
                    sr <= {1'b0, sr[7:0]};
                end
                cnt <= cnt + 1'b1;
            end
        end else if (~opn_valid && prev_opn_valid) begin
            prev_opn_valid <= 1'b0;
        end

        if (res_valid && ~opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule