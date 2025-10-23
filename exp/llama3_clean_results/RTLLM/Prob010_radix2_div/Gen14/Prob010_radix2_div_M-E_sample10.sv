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

reg [7:0] dividend_pipe [7:0];
reg [7:0] divisor_reg;
reg [7:0] quotient_reg;
reg [7:0] remainder_reg;
reg [2:0] cnt;
reg res_valid_reg;

localparam IDLE = 3'b000;
localparam INIT = 3'b001;
localparam DIVIDE = 3'b010;
localparam COMPLETE = 3'b100;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        res_valid_reg <= 0;
        quotient_reg <= 0;
        remainder_reg <= 0;
        divisor_reg <= 0;
        for (int i = 0; i < 8; i++) begin
            dividend_pipe[i] <= 0;
        end
    end else begin
        case({res_valid_reg, cnt})
            {1'b0, 3'b000}: begin
                if (opn_valid) begin
                    res_valid_reg <= 1;
                    cnt <= 1;
                    divisor_reg <= divisor;
                    dividend_pipe[0] <= dividend;
                end
            end
            {1'b0, 3'b001}: begin
                if (divisor_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[1] <= dividend_pipe[0] << 1;
                cnt <= cnt + 1;
            end
            {1'b0, 3'b010}: begin
                if (remainder_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[2] <= dividend_pipe[1] << 1;
                cnt <= cnt + 1;
            end
            {1'b0, 3'b011}: begin
                if (remainder_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[3] <= dividend_pipe[2] << 1;
                cnt <= cnt + 1;
            end
            {1'b0, 3'b100}: begin
                if (remainder_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[4] <= dividend_pipe[3] << 1;
                cnt <= cnt + 1;
            end
            {1'b0, 3'b101}: begin
                if (remainder_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[5] <= dividend_pipe[4] << 1;
                cnt <= cnt + 1;
            end
            {1'b0, 3'b110}: begin
                if (remainder_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[6] <= dividend_pipe[5] << 1;
                cnt <= cnt + 1;
            end
            {1'b0, 3'b111}: begin
                if (remainder_reg[7] == 1'b1) begin
                    quotient_reg <= quotient_reg + 1;
                    remainder_reg <= remainder_reg - divisor_reg;
                end
                dividend_pipe[7] <= dividend_pipe[6] << 1;
                cnt <= 0;
                res_valid_reg <= 0;
                result <= {remainder_reg, quotient_reg};
                res_valid <= 1;
            end
            default: begin
                res_valid_reg <= 0;
                res_valid <= 0;
            end
        endcase
    end
end

endmodule