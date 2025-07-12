module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

// FSM States
localparam IDLE   = 2'b00;
localparam DIVIDE = 2'b01;
localparam DONE   = 2'b10;

reg [1:0] state, next_state;

// Registers for absolute values and signs
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;

reg dividend_neg;
reg divisor_neg;

reg quotient_neg;
reg remainder_neg;

reg [3:0] count; // iteration counter (0-8)

reg [16:0] shift_reg; 
// shift_reg[16:9] = partial remainder (9 bits)
// shift_reg[8:1] = quotient (8 bits)
// shift_reg[0] unused or shifting purpose

wire [8:0] partial_remainder = shift_reg[16:8]; // 9-bit partial remainder
wire [8:0] subtract_value = {1'b0, abs_divisor};

// Subtraction result of partial_remainder - abs_divisor
wire [9:0] sub_res = {1'b0, partial_remainder} - {1'b0, subtract_value};
// If MSB of sub_res is 0, subtraction >= 0

// Helper function to get absolute value and sign
function [7:0] abs_val;
    input [7:0] in;
    input       is_signed;
    begin
        if (is_signed && in[7]) abs_val = (~in + 1'b1);
        else                    abs_val = in;
    end
endfunction

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state         <= IDLE;
        res_valid     <= 1'b0;
        result        <= 16'd0;
        abs_dividend  <= 8'd0;
        abs_divisor   <= 8'd0;
        dividend_neg  <= 1'b0;
        divisor_neg   <= 1'b0;
        quotient_neg  <= 1'b0;
        remainder_neg <= 1'b0;
        count         <= 4'd0;
        shift_reg     <= 17'd0;
    end else begin
        state <= next_state;

        case(state)
        IDLE: begin
            res_valid <= 1'b0;
            if (opn_valid) begin
                // Capture signs and absolute values
                dividend_neg <= sign & dividend[7];
                divisor_neg  <= sign & divisor[7];
                abs_dividend <= abs_val(dividend, sign);
                abs_divisor  <= abs_val(divisor, sign);

                quotient_neg  <= sign & (dividend[7] ^ divisor[7]);
                remainder_neg <= sign & dividend[7];

                count <= 4'd0;

                // Initialize shift_reg with dividend shifted left 1, quotient zero
                // partial remainder: 9 bits = dividend abs with a 0 LSB for shifting
                // quotient: 8 bits = zero
                // shift_reg = {partial_remainder[8:0], quotient[7:0]}
                shift_reg <= {abs_val(dividend, sign), 1'b0, 8'd0};
            end
        end

        DIVIDE: begin
            count <= count + 1'b1;

            if (abs_divisor == 8'd0) begin
                // Division by zero: define quotient=0, remainder=dividend
                // Keep shift_reg unchanged or set quotient 0, remainder dividend abs
                // But iteration completes immediately here, will handle in DONE
                shift_reg <= shift_reg;
            end else if (~sub_res[9]) begin
                // subtraction success: partial_remainder = sub_res[8:0], quotient bit = 1
                shift_reg <= {sub_res[8:0], shift_reg[7:1], 1'b1};
            end else begin
                // subtraction fail: partial_remainder unchanged, quotient bit = 0
                shift_reg <= {partial_remainder, shift_reg[7:1], 1'b0};
            end
        end

        DONE: begin
            // Apply sign correction to quotient and remainder

            // Extract quotient and remainder from shift_reg
            // remainder in shift_reg[16:9] (8 bits in MSB except 1 LSB extra bit)
            // Quotient in shift_reg[8:1]

            reg [7:0] quotient_val;
            reg [7:0] remainder_val;

            quotient_val = shift_reg[8:1];
            remainder_val = shift_reg[16:9];

            // Handle division by zero: quotient=0, remainder=dividend
            if (abs_divisor == 8'd0) begin
                quotient_val = 8'd0;
                remainder_val = abs_dividend;
            end

            // Adjust sign of quotient
            if (quotient_neg)
                quotient_val = (~quotient_val) + 1'b1;

            // Adjust sign of remainder
            if (remainder_neg)
                remainder_val = (~remainder_val) + 1'b1;

            result <= {remainder_val, quotient_val};
            res_valid <= 1'b1;
        end
        endcase
    end
end

// Next state logic
always @(*) begin
    case(state)
    IDLE: begin
        if (opn_valid)
            next_state = DIVIDE;
        else
            next_state = IDLE;
    end

    DIVIDE: begin
        if (count == 4'd8)
            next_state = DONE;
        else
            next_state = DIVIDE;
    end

    DONE: begin
        // Wait until res_valid consumed (not specified here, assume res_valid stays until next op)
        // So transition to IDLE once new opn_valid arrives or stay DONE
        // For simplicity, return to IDLE when opn_valid low
        if (!opn_valid)
            next_state = IDLE;
        else
            next_state = DONE;
    end

    default: next_state = IDLE;
    endcase
end

endmodule