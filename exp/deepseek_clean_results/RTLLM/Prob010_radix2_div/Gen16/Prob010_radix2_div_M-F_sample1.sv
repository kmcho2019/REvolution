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
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [2*WIDTH-1:0] SR;       // [remainder|quotient]
reg quotient_sign;
reg divide_by_zero;

// Absolute values
wire [WIDTH-1:0] dividend_abs = (sign & dividend[WIDTH-1]) ? -dividend : dividend;
wire [WIDTH-1:0] divisor_abs = (sign & divisor[WIDTH-1]) ? -divisor : divisor;

// Arithmetic operations
wire [WIDTH-1:0] divisor_neg = -divisor_abs;
wire [WIDTH:0] sub_result = {1'b0, SR[2*WIDTH-1:WIDTH]} + {1'b0, divisor_neg};
wire sub_ok = sub_result[WIDTH];  // remainder >= divisor if carry out

// Next state logic
wire op_start = opn_valid && !res_valid;
wire calc_done = (cnt == WIDTH);

// State machine
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
                    SR <= {WIDTH'b0, dividend_abs};
                    cnt <= 0;
                    state <= divide_by_zero ? DONE : CALC;
                end
            end
            
            CALC: begin
                if (calc_done) begin
                    state <= DONE;
                end else begin
                    if (sub_ok) begin
                        SR <= {sub_result[WIDTH-1:0], SR[WIDTH-1:0], 1'b1};
                    end else begin
                        SR <= {SR[2*WIDTH-2:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (divide_by_zero) begin
                    result <= {dividend, {WIDTH{1'b1}}};
                end else begin
                    result <= {
                        (sign & dividend[WIDTH-1]) ? -SR[2*WIDTH-1:WIDTH] : SR[2*WIDTH-1:WIDTH],
                        quotient_sign ? -SR[WIDTH-1:0] : SR[WIDTH-1:0]
                    };
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule