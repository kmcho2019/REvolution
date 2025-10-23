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

reg [2:0] cnt;          // 0-7 counter (8 cycles)
reg [15:0] SR;          // Shift register [remainder|quotient]

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        if (|cnt) begin  // Calculation in progress
            // Perform subtraction and shift
            if ({1'b0, SR[15:8]} >= {1'b0, divisor}) begin
                SR <= {SR[15:8] - divisor, SR[7:0], 1'b1};
            end else begin
                SR <= {SR[14:0], 1'b0};
            end

            if (cnt == 3'd7) begin
                // Final result assembly
                if (divisor == 0) begin
                    result <= 16'hFFFF;  // Division by zero
                end else begin
                    // Handle signed results
                    reg [7:0] rem = sign & dividend[7] ? -SR[15:8] : SR[15:8];
                    reg [7:0] quo = (sign & (dividend[7] ^ divisor[7])) ? -SR[7:0] : SR[7:0];
                    result <= {rem, quo};
                end
                res_valid <= 1;
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Initialize operation
            SR <= {8'b0, sign & dividend[7] ? -dividend : dividend, 1'b0};
            cnt <= 1;
            res_valid <= 0;
        end else if (!opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule