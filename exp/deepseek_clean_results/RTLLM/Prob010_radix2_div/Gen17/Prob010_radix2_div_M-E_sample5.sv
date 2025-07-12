module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg res_ready,  // Added to match testbench
    output reg [15:0] result
);

// Pipeline stages
localparam IDLE = 2'b00;
localparam PREP = 2'b01;
localparam DIV  = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state;
reg [3:0] cnt;  // 4-bit counter for 8 iterations
reg [15:0] div_reg;  // {remainder, quotient}
reg [7:0] divisor_abs;
reg [7:0] divisor_neg;
reg quotient_sign;
reg remainder_sign;
reg divide_by_zero;
reg early_term;

// Absolute value calculation
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs_val = sign & divisor[7] ? -divisor : divisor;

// Early termination detection
wire remainder_zero = (div_reg[15:8] == 8'b0);

// Carry-save subtraction
wire [8:0] sub_result = {1'b0, div_reg[15:8]} + {1'b0, divisor_neg};
wire sub_ok = ~sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        res_ready <= 1;
        result <= 0;
        cnt <= 0;
        div_reg <= 0;
        divide_by_zero <= 0;
        early_term <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                res_ready <= 1;
                if (opn_valid && res_ready) begin
                    res_ready <= 0;
                    divide_by_zero <= (divisor == 0);
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];
                    divisor_abs <= divisor_abs_val;
                    divisor_neg <= -divisor_abs_val;
                    
                    if (divisor == 0) begin
                        result <= {dividend, 8'hFF};  // Divide by zero pattern
                        res_valid <= 1;
                        res_ready <= 1;
                    end else begin
                        div_reg <= {8'b0, dividend_abs};
                        cnt <= 0;
                        early_term <= 0;
                        state <= PREP;
                    end
                end
            end
            
            PREP: begin
                // Normalize by shifting out leading zeros
                if (div_reg[14:8] == 7'b0 && cnt < 4'd7) begin
                    div_reg <= div_reg << 1;
                    cnt <= cnt + 1;
                end else begin
                    state <= DIV;
                end
            end
            
            DIV: begin
                if (early_term || cnt == 4'd8) begin
                    state <= DONE;
                end else begin
                    if (sub_ok) begin
                        div_reg <= {sub_result[7:0], div_reg[6:0], 1'b1};
                    end else begin
                        div_reg <= {div_reg[14:0], 1'b0};
                    end
                    
                    early_term <= remainder_zero;
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Sign correction and result packing
                result[15:8] <= remainder_sign ? -div_reg[15:8] : div_reg[15:8];
                result[7:0] <= quotient_sign ? -div_reg[7:0] : div_reg[7:0];
                res_valid <= 1;
                res_ready <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule