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

reg [1:0] state;
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] shift_register;
reg [3:0] counter;
reg [7:0] quotient;
reg [7:0] remainder;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_register <= 0;
        counter <= 0;
        quotient <= 0;
        remainder <= 0;
        res_valid <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (opn_valid && !res_valid) begin
                    if (sign) begin
                        dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                        divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
                    end else begin
                        dividend_reg <= dividend;
                        divisor_reg <= divisor;
                    end
                    shift_register <= {8'd0, dividend_reg};
                    state <= 1;
                    counter <= 1;
                end
            end
            1: begin // PROCESS
                if (counter < 8) begin
                    reg [8:0] temp;
                    temp <= {1'b0, shift_register[15:8]} - {1'b0, divisor_reg};
                    if (temp[8]) begin
                        shift_register <= {shift_register[15:8] + divisor_reg, shift_register[7:0], 1'b0};
                    end else begin
                        shift_register <= {temp[7:0], shift_register[7:0], 1'b1};
                    end
                    counter <= counter + 1;
                end else begin
                    remainder <= shift_register[15:8];
                    quotient <= shift_register[7:0];
                    if (sign && (dividend[7] != divisor[7])) begin
                        quotient <= ~quotient + 1;
                        remainder <= ~remainder + 1;
                    end
                    state <= 2;
                end
            end
            2: begin // RESULT
                result <= {remainder, quotient};
                res_valid <= 1;
                state <= 0;
            end
        endcase
    end
end

endmodule