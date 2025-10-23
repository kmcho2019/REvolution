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

// States
localparam IDLE = 2'b00;
localparam INIT = 2'b01;
localparam CALC = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] SR;       // [remainder|quotient]
reg quotient_sign;

// Absolute values
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (sign & divisor[7]) ? -divisor : divisor;

// Arithmetic operations
wire [7:0] divisor_neg = -divisor_abs;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, divisor_neg};
wire sub_ok = sub_result[8];  // remainder >= divisor if carry out

// Next state logic
wire op_start = opn_valid && !res_valid;
wire calc_done = (cnt == 8);
wire divide_by_zero = (divisor == 0);

// State machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        SR <= 0;
        quotient_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (op_start) begin
                    state <= divide_by_zero ? DONE : INIT;
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                end
            end
            
            INIT: begin
                SR <= {8'b0, dividend_abs};
                cnt <= 0;
                state <= CALC;
            end
            
            CALC: begin
                if (calc_done) begin
                    state <= DONE;
                end else begin
                    SR <= sub_ok ? {sub_result[7:0], SR[7:1], 1'b1} 
                                : {SR[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                result <= divide_by_zero ? {dividend, 8'hFF} :
                       { (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                         quotient_sign ? -SR[7:0] : SR[7:0] };
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule