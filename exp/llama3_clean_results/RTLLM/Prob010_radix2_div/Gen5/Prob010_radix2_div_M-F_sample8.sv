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

reg [8:0] sr;  // shift register with 1 extra bit for carry
reg [7:0] neg_divisor;  // negated absolute value of divisor
reg [3:0] cnt;  // counter
reg start_div;  // flag to start division

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 9'b0;
        neg_divisor <= 8'b0;
        cnt <= 4'b0;
        start_div <= 1'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize registers
            if (sign) begin
                // Signed division
                sr <= {1'b0, (dividend[7] ? ~dividend + 8'b1 : dividend)};  // shift left by one bit
            end else begin
                // Unsigned division
                sr <= {1'b0, dividend};  // shift left by one bit
            end
            neg_divisor <= (divisor[7] ? ~divisor + 8'b1 : divisor);
            cnt <= 4'b1;
            start_div <= 1'b1;
        end else if (start_div) begin
            // Division process
            if (cnt == 4'b1000) begin
                // Division complete
                start_div <= 1'b0;
                result <= {sr[8], sr[7:0]};  // update result with remainder and quotient
                res_valid <= 1'b1;
            end else begin
                // Update shift register
                if (sr[8] == 1'b0) begin
                    if (sr[7:0] >= neg_divisor) begin
                        sr <= {1'b0, sr[7:0] - neg_divisor, 1'b1};  // shift left and insert carry-out
                    end else begin
                        sr <= {1'b1, sr[7:0], 1'b0};  // shift left and insert carry-out
                    end
                end else begin
                    if ({1'b0, sr[7:0]} >= neg_divisor) begin
                        sr <= {1'b0, sr[7:0] - neg_divisor, 1'b1};  // shift left and insert carry-out
                    end else begin
                        sr <= {1'b1, sr[7:0], 1'b0};  // shift left and insert carry-out
                    end
                end
                cnt <= cnt + 1'b1;
            end
        end else if (!opn_valid && res_valid) begin
            // Reset result validity
            res_valid <= 1'b0;
        end
    end
end

endmodule