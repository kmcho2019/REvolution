module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [3:0] cnt;
reg [15:0] sr;
reg div_by_zero;
reg q_sign, r_sign;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        div_by_zero <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Initialize operation
            q_sign <= sign & (dividend[7] ^ divisor[7]);
            r_sign <= sign & dividend[7];
            div_by_zero <= (divisor == 0);
            sr <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
            cnt <= 1;
            res_valid <= 0;
        end else if (cnt > 0 && cnt < 9) begin
            // Division step
            if (sr[15:8] >= ((sign & divisor[7]) ? -divisor : divisor)) begin
                sr <= {sr[15:8] - ((sign & divisor[7]) ? -divisor : divisor), 
                       sr[7:0], 1'b1};
            end else begin
                sr <= {sr[15:8], sr[7:0], 1'b0};
            end
            cnt <= cnt + 1;
        end else if (cnt == 9) begin
            // Finalize result
            res_valid <= 1;
            if (div_by_zero) begin
                result <= 16'hFFFF;
            end else begin
                result <= {
                    r_sign ? -sr[15:8] : sr[15:8],
                    q_sign ? -sr[7:0] : sr[7:0]
                };
            end
            cnt <= 0;
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule