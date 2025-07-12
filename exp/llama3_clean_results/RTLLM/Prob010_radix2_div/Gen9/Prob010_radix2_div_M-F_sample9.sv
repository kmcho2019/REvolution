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

reg [2:0] state;  // state machine
reg [7:0] dividend_reg;  // registered dividend
reg [7:0] divisor_reg;  // registered divisor
reg [7:0] quotient;  // quotient
reg [8:0] remainder;  // remainder
reg [3:0] cnt;  // counter

// Next state logic
wire [2:0] next_state;
assign next_state = (state == 3'd0 && opn_valid && divisor != 8'd0) ? 3'd1 :
                    (state == 3'd1) ? 3'd2 :
                    (state == 3'd2 && cnt == 4'd8) ? 3'd3 :
                    (state == 3'd3) ? 3'd0 : state;

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 3'd0;  // IDLE state
        res_valid <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == 3'd1) begin  // INIT state
            if (sign) begin
                dividend_reg <= (dividend[7])? ~dividend + 1 : dividend;
                divisor_reg <= (divisor[7])? ~divisor + 1 : divisor;
            end else begin
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            cnt <= 4'd0;
            quotient <= 8'd0;
            remainder <= {1'b0, dividend_reg};
        end else if (next_state == 3'd2) begin  // DIVIDE state
            if (remainder[8]) begin
                remainder <= {remainder[7:0], 1'b0} - {1'b0, divisor_reg};
                quotient <= quotient + (1 << cnt);
            end else begin
                remainder <= {remainder[7:0], 1'b0};
            end
            cnt <= cnt + 1;
        end else if (next_state == 3'd3) begin  // RESULT state
            if (sign) begin
                if (dividend[7] != divisor[7]) begin
                    quotient <= ~quotient + 1;
                end
                if (remainder[8]) begin
                    remainder <= {remainder[7:0], 1'b0} + {1'b0, divisor_reg};
                end
            end
            result <= {remainder[7:0], quotient};
            res_valid <= 1'b1;
        end else if (next_state == 3'd0 && opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule