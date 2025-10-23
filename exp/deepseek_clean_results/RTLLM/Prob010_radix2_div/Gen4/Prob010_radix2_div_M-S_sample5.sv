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

reg [2:0] cnt;
reg busy;
reg [15:0] sr;  // Combined shift register [remainder:quotient]

wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire [8:0] sub_result = {sr[15:8], sr[7]} + {1'b0, ~abs_divisor} + 9'b1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        busy <= 0;
        cnt <= 0;
        sr <= 0;
        result <= 0;
    end else begin
        res_valid <= 0;
        
        if (!busy) begin
            if (opn_valid) begin
                if (divisor == 0) begin
                    result <= {8'hFF, 8'hFF};  // Div by zero encoding
                    res_valid <= 1;
                end else if (dividend == 0) begin
                    result <= 0;
                    res_valid <= 1;
                end else begin
                    sr <= {8'b0, abs_dividend};
                    cnt <= 0;
                    busy <= 1;
                end
            end
        end else begin
            if (cnt == 3'd7) begin
                // Finalize result with sign correction
                if (sign) begin
                    sr[15:8] <= (dividend[7]) ? -sr[15:8] : sr[15:8];
                    sr[7:0] <= (dividend[7] ^ divisor[7]) ? -sr[7:0] : sr[7:0];
                end
                result <= sr;
                res_valid <= 1;
                busy <= 0;
            end else begin
                // Radix-2 division step
                if (!sub_result[8]) begin
                    sr <= {sub_result[7:0], sr[6:0], 1'b1};
                end else begin
                    sr <= {sr[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule