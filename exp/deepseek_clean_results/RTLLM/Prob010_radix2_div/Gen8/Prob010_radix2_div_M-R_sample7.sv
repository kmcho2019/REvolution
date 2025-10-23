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

// State definitions
localparam IDLE   = 2'b00;
localparam RUNNING = 2'b01;
localparam DONE    = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [7:0] abs_dividend, abs_divisor;
reg dividend_neg, divisor_neg;

// Division registers
reg [7:0] quotient;
reg [7:0] partial_rem;

// Combinational signals
wire [8:0] sub_result = {partial_rem, quotient[7]} + {1'b0, abs_divisor};
wire carry_out = sub_result[8];
wire division_by_zero = (divisor == 0);

// Absolute value calculation
wire [7:0] next_abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] next_abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// State transition logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        dividend_neg <= 0;
        divisor_neg <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !division_by_zero) begin
                    state <= RUNNING;
                    abs_dividend <= next_abs_dividend;
                    abs_divisor <= next_abs_divisor;
                    dividend_neg <= sign & dividend[7];
                    divisor_neg <= sign & divisor[7];
                    quotient <= 0;
                    partial_rem <= 0;
                    cnt <= 0;
                end else if (opn_valid && division_by_zero) begin
                    result <= {8'hFF, 8'hFF};
                    res_valid <= 1;
                    state <= DONE;
                end
            end
            
            RUNNING: begin
                if (cnt < 8) begin
                    // Non-restoring division step
                    if (partial_rem[7]) begin
                        {partial_rem, quotient} <= {partial_rem + abs_divisor, quotient[6:0], 1'b0};
                    end else begin
                        {partial_rem, quotient} <= {sub_result[7:0], quotient[6:0], ~carry_out};
                    end
                    cnt <= cnt + 1;
                end else begin
                    // Final correction step
                    if (partial_rem[7]) begin
                        partial_rem <= partial_rem + abs_divisor;
                        quotient <= quotient - 1;
                    end
                    state <= DONE;
                end
            end
            
            DONE: begin
                // Apply signs to results
                result[15:8] <= dividend_neg ? -partial_rem : partial_rem;
                result[7:0] <= (dividend_neg ^ divisor_neg) ? -quotient : quotient;
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule