module radix2_div #(
    parameter WIDTH = 8
) (
    input clk,
    input rst,
    input sign,
    input [WIDTH-1:0] dividend,
    input [WIDTH-1:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [2*WIDTH-1:0] result
);

// States
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

reg state;
reg [3:0] cnt;
reg [WIDTH-1:0] remainder;
reg [WIDTH-1:0] quotient;
reg quotient_sign;
reg divide_by_zero;

// Absolute values and arithmetic
wire [WIDTH-1:0] dividend_abs = sign & dividend[WIDTH-1] ? -dividend : dividend;
wire [WIDTH-1:0] divisor_abs = sign & divisor[WIDTH-1] ? -divisor : divisor;
wire [WIDTH-1:0] divisor_neg = -divisor_abs;

// Subtraction result and comparison
wire [WIDTH:0] sub_result = {1'b0, remainder} + {1'b0, divisor_neg};
wire sub_ok = ~sub_result[WIDTH];  // 1 if remainder >= divisor

// Control signals
wire op_start = opn_valid && !res_valid;
wire calc_done = (cnt == WIDTH);

// Next state and output logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        remainder <= 0;
        quotient <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (op_start) begin
                    divide_by_zero <= (divisor == 0);
                    quotient_sign <= sign & (dividend[WIDTH-1] ^ divisor[WIDTH-1]);
                    remainder <= dividend_abs;
                    quotient <= 0;
                    cnt <= 0;
                    state <= divide_by_zero ? IDLE : CALC;
                end
            end
            
            CALC: begin
                if (calc_done) begin
                    // Finalize result with sign handling
                    result <= divide_by_zero ? {dividend, {WIDTH{1'b1}}} :
                             { (sign & dividend[WIDTH-1]) ? -remainder : remainder,
                               quotient_sign ? -quotient : quotient };
                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    // Perform division step
                    if (sub_ok) begin
                        remainder <= sub_result[WIDTH-1:0];
                        quotient <= {quotient[WIDTH-2:0], 1'b1};
                    end else begin
                        remainder <= {remainder[WIDTH-2:0], quotient[WIDTH-1]};
                        quotient <= {quotient[WIDTH-2:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule