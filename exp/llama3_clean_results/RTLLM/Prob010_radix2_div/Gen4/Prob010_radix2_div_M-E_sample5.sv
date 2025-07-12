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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient;
reg [7:0] remainder;
reg [2:0] state;
reg [3:0] cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'b000;
        cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient <= 0;
        remainder <= 0;
        res_valid <= 0;
    end else begin
        case (state)
            3'b000: begin // idle state
                if (opn_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    state <= 3'b001;
                    cnt <= 0;
                    quotient <= 0;
                    remainder <= dividend_reg;
                end
            end
            3'b001: begin // divide state
                if (cnt < 8) begin
                    if (remainder >= divisor_reg) begin
                        remainder <= remainder - divisor_reg;
                        quotient <= quotient + (1 << cnt);
                    end
                    remainder <= remainder << 1;
                    cnt <= cnt + 1;
                end else begin
                    state <= 3'b010;
                end
            end
            3'b010: begin // complete state
                result <= {remainder, quotient};
                res_valid <= 1;
                state <= 3'b000;
            end
        endcase
    end
end

endmodule