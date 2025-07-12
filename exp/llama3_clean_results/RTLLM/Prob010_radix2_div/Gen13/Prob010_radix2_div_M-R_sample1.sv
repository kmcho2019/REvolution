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
reg [7:0] remainder_reg;
reg [7:0] quotient_reg;
reg [2:0] state;
reg [3:0] counter;

// Combinational logic for next state and operations
assign next_state = (state == 0 && opn_valid) ? 1 :
                    (state == 1) ? 2 :
                    (state == 2 && counter < 8) ? 2 :
                    (state == 2 && counter >= 8) ? 3 :
                    0;

assign next_counter = (state == 2) ? counter + 1 : 0;
assign next_quotient = (state == 2 && remainder_reg >= divisor_reg) ? (quotient_reg << 1) | 1'b1 : (quotient_reg << 1);
assign next_remainder = (state == 2 && remainder_reg >= divisor_reg) ? remainder_reg - divisor_reg : remainder_reg;

// Sequential logic for state and operation updates
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        remainder_reg <= 0;
        quotient_reg <= 0;
        counter <= 0;
    end else begin
        case (next_state)
            0: begin // IDLE
                res_valid <= 0;
            end
            1: begin // INIT
                if (sign) begin
                    dividend_reg <= (dividend[7]? ~dividend + 1 : dividend);
                    divisor_reg <= (divisor[7]? ~divisor + 1 : divisor);
                end else begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                end
                remainder_reg <= {1'b0, dividend_reg};
                quotient_reg <= 0;
                counter <= 1;
            end
            2: begin // DIVIDE
                remainder_reg <= next_remainder;
                quotient_reg <= next_quotient;
                counter <= next_counter;
            end
            3: begin // RESULT
                result <= {remainder_reg, quotient_reg};
                res_valid <= 1;
            end
        endcase
        state <= next_state;
    end
end

endmodule