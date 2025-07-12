module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result,
    output wire div_by_zero,
    output wire overflow
);

// Pipeline stages
localparam IDLE = 0;
localparam INIT = 1;
localparam PROCESS = 2;
localparam FINISH = 3;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] shift_reg; // [remainder|quotient]
reg quotient_sign;
reg processing;

// Absolute value computation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Division signals
wire [7:0] neg_divisor = -abs_divisor;
wire [8:0] sub_result = {1'b0, shift_reg[15:8]} + {1'b0, neg_divisor};
wire sub_valid = sub_result[8]; // Carry indicates valid subtraction

// Control signals
wire start_division = opn_valid && !res_valid;
assign div_by_zero = (divisor == 8'b0);
assign overflow = (divisor == 8'b1) && (dividend == 8'h80) && sign;

// Early termination detection
wire remainder_zero = (shift_reg[15:8] == 8'b0);
wire early_done = (cnt > 0) && remainder_zero;

// Main state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        shift_reg <= 0;
        quotient_sign <= 0;
        processing <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start_division) begin
                    state <= div_by_zero ? FINISH : INIT;
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                end
                res_valid <= 0;
            end
            
            INIT: begin
                shift_reg <= {8'b0, abs_dividend};
                cnt <= 0;
                state <= PROCESS;
                processing <= 1;
            end
            
            PROCESS: begin
                if (early_done || cnt == 8) begin
                    state <= FINISH;
                    processing <= 0;
                end else begin
                    shift_reg <= sub_valid ? 
                        {sub_result[7:0], shift_reg[7:1], 1'b1} :
                        {shift_reg[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            FINISH: begin
                if (div_by_zero) begin
                    result <= {dividend, 8'hFF}; // Error code
                end else if (overflow) begin
                    result <= {8'h00, 8'h80}; // Special overflow case
                end else begin
                    // Apply sign correction
                    result <= {
                        (sign & dividend[7]) ? -shift_reg[15:8] : shift_reg[15:8],
                        quotient_sign ? -shift_reg[7:0] : shift_reg[7:0]
                    };
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule