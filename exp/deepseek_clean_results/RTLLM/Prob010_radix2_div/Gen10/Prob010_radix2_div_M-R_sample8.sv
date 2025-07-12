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

reg [1:0] state;
reg [3:0] cnt;
reg [16:0] sr;
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;
wire calculation_done = (cnt == 8);
wire [7:0] remainder = sr[16:9];
wire [7:0] quotient = sr[8:1];
wire [7:0] neg_divisor = -divisor_abs;

localparam IDLE = 0;
localparam BUSY = 1;

// Next state logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: state <= (opn_valid && !res_valid) ? BUSY : IDLE;
            BUSY: state <= calculation_done ? IDLE : BUSY;
        endcase
    end
end

// Control signals and data path
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        div_by_zero <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        dividend_abs <= 0;
        divisor_abs <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Capture inputs and signs
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    dividend_abs <= (sign & dividend[7]) ? -dividend : dividend;
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    div_by_zero <= (divisor == 0);
                    
                    // Initialize shift register (shifted left by 1)
                    sr <= {8'b0, dividend_abs, 1'b0};
                    cnt <= 0;
                end
            end
            
            BUSY: begin
                if (!calculation_done) begin
                    // Perform one division step
                    if (remainder >= divisor_abs) begin
                        sr <= {remainder - divisor_abs, quotient, 1'b1};
                    end else begin
                        sr <= {remainder, quotient, 1'b0};
                    end
                    cnt <= cnt + 1;
                end else begin
                    // Finalize result
                    res_valid <= 1;
                    if (div_by_zero) begin
                        result <= 16'hFFFF;  // Error pattern
                    end else begin
                        // Apply sign correction
                        result <= {
                            dividend_sign ? -remainder : remainder,
                            (dividend_sign ^ divisor_sign) ? -quotient : quotient
                        };
                    end
                end
            end
        endcase
    end
end

endmodule