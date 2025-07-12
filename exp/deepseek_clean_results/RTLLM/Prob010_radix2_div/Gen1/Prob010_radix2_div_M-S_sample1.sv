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

reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [3:0] cnt;
reg dividing;
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = SR[15:7] + {1'b0, ~abs_divisor} + 1'b1;
wire carry_out = sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        dividing <= 0;
        SR <= 0;
    end else begin
        if (dividing) begin
            if (cnt == 8) begin
                // Final result processing
                if (sign) begin
                    result <= {(dividend[7] ? -SR[15:8] : SR[15:8]), 
                              ((dividend[7] ^ divisor[7]) ? -SR[7:0] : SR[7:0])};
                end else begin
                    result <= {SR[15:8], SR[7:0]};
                end
                res_valid <= 1;
                dividing <= 0;
            end else begin
                // Perform subtraction and shift
                SR <= carry_out ? 
                     {sub_result[7:0], SR[6:0], 1'b1} : 
                     {SR[14:0], 1'b0};
                cnt <= cnt + 1;
            end
        end else if (opn_valid && !res_valid) begin
            // Start new division
            SR <= {8'b0, abs_dividend, 1'b0};
            cnt <= 0;
            dividing <= 1;
            res_valid <= 0;
        end

        // Clear valid when result is read
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule