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
typedef enum logic [1:0] {
    IDLE,
    CALC,
    DONE
} state_t;

state_t state;
reg [3:0] cnt;
reg [2*WIDTH:0] SR;  // Extra bit for shift operation
reg quotient_sign;
reg divide_by_zero;

// Absolute values and signs
wire signed [WIDTH-1:0] signed_dividend = dividend;
wire signed [WIDTH-1:0] signed_divisor = divisor;
wire [WIDTH-1:0] dividend_abs = sign & signed_dividend[WIDTH-1] ? -signed_dividend : signed_dividend;
wire [WIDTH-1:0] divisor_abs = sign & signed_divisor[WIDTH-1] ? -signed_divisor : signed_divisor;

// Arithmetic operations
wire [WIDTH:0] sub_result = {1'b0, SR[2*WIDTH:WIDTH+1]} + {1'b0, -divisor_abs};
wire sub_ok = ~sub_result[WIDTH];  // Non-negative result

// Control signals
wire op_start = opn_valid && !res_valid;
wire calc_done = (cnt == WIDTH);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (op_start) begin
                    divide_by_zero <= (divisor == 0);
                    quotient_sign <= sign & (dividend[WIDTH-1] ^ divisor[WIDTH-1]);
                    SR <= {1'b0, {WIDTH{1'b0}}, dividend_abs};
                    cnt <= 0;
                    state <= divide_by_zero ? DONE : CALC;
                end
            end
            
            CALC: begin
                if (calc_done) begin
                    state <= DONE;
                end else begin
                    SR <= sub_ok ? {sub_result[WIDTH-1:0], SR[WIDTH:0], 1'b1} 
                                : {SR[2*WIDTH-1:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (divide_by_zero) begin
                    result <= {dividend, {WIDTH{1'b1}}};  // Divide by zero special case
                end else begin
                    result <= {
                        (sign & dividend[WIDTH-1]) ? -SR[2*WIDTH:WIDTH+1] : SR[2*WIDTH:WIDTH+1],
                        quotient_sign ? -SR[WIDTH:1] : SR[WIDTH:1]
                    };
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule