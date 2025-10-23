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
typedef enum logic [1:0] {
    IDLE,
    PREPARE,
    DIVIDE,
    FINISH
} state_t;

state_t state, next_state;

// Internal registers
reg [7:0] abs_dividend, abs_divisor;
reg [15:0] partial_remainder;
reg [7:0] quotient;
reg [2:0] bit_counter;
reg quotient_sign, remainder_sign;
reg division_by_zero;
reg early_termination;

// Parallel computation signals
wire [8:0] add_path = {partial_remainder[14:7], 1'b0} + {1'b0, abs_divisor};
wire [8:0] sub_path = {partial_remainder[14:7], 1'b0} - {1'b0, abs_divisor};
wire add_sign = add_path[8];
wire sub_sign = sub_path[8];

// Leading zero detection
wire [2:0] dividend_leading_zeros;
wire [2:0] divisor_leading_zeros;
leading_zero_counter lzc_dividend (.in(abs_dividend), .count(dividend_leading_zeros));
leading_zero_counter lzc_divisor (.in(abs_divisor), .count(divisor_leading_zeros));

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (opn_valid) next_state = PREPARE;
        PREPARE: next_state = DIVIDE;
        DIVIDE: if (bit_counter == 3'd7 || early_termination) next_state = FINISH;
        FINISH: next_state = IDLE;
    endcase
end

// Datapath
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        partial_remainder <= 0;
        quotient <= 0;
        bit_counter <= 0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    abs_dividend <= sign & dividend[7] ? -dividend : dividend;
                    abs_divisor <= sign & divisor[7] ? -divisor : divisor;
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];
                    division_by_zero <= (divisor == 0);
                end
            end
            
            PREPARE: begin
                partial_remainder <= {8'b0, abs_dividend} << 1;
                quotient <= 0;
                bit_counter <= 0;
                early_termination <= (abs_dividend == 0) || (abs_divisor == 1);
            end
            
            DIVIDE: begin
                if (!early_termination) begin
                    // Non-restoring division step
                    if (partial_remainder[15]) begin
                        // Negative remainder - take add path
                        partial_remainder <= {add_path[7:0], partial_remainder[6:0], 1'b0};
                        quotient <= {quotient[6:0], ~add_sign};
                    end else begin
                        // Positive remainder - take sub path
                        partial_remainder <= {sub_path[7:0], partial_remainder[6:0], 1'b0};
                        quotient <= {quotient[6:0], sub_sign};
                    end
                    bit_counter <= bit_counter + 1;
                end
            end
            
            FINISH: begin
                if (division_by_zero) begin
                    result <= 16'hFFFF; // Error indication
                end else if (early_termination) begin
                    if (abs_divisor == 1) begin
                        result <= {8'b0, quotient_sign ? -abs_dividend : abs_dividend};
                    end else begin
                        result <= 16'b0;
                    end
                end else begin
                    // Final remainder adjustment
                    if (partial_remainder[15]) begin
                        partial_remainder[15:8] <= partial_remainder[15:8] + abs_divisor;
                    end
                    
                    // Apply sign correction
                    result[7:0] <= quotient_sign ? -quotient : quotient;
                    result[15:8] <= remainder_sign ? -partial_remainder[15:8] : partial_remainder[15:8];
                end
                res_valid <= 1;
            end
        endcase
    end
end

// Leading zero counter module
module leading_zero_counter (
    input [7:0] in,
    output reg [2:0] count
);
always_comb begin
    casez (in)
        8'b1???????: count = 3'd0;
        8'b01??????: count = 3'd1;
        8'b001?????: count = 3'd2;
        8'b0001????: count = 3'd3;
        8'b00001???: count = 3'd4;
        8'b000001??: count = 3'd5;
        8'b0000001?: count = 3'd6;
        8'b00000001: count = 3'd7;
        default: count = 3'd7;
    endcase
end
endmodule

endmodule