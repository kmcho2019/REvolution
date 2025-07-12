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

// State machine definitions
localparam IDLE = 1'b0;
localparam CALCULATE = 1'b1;

reg state;
reg [3:0] cnt;
reg [7:0] dividend_buf;
reg [7:0] divisor_buf;
reg signed_op;
reg div_by_zero;

// Working registers
reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] divisor_abs;

// Intermediate signals
wire [7:0] dividend_abs = signed_op & dividend_buf[7] ? -dividend_buf : dividend_buf;
wire [7:0] divisor_tmp = signed_op & divisor_buf[7] ? -divisor_buf : divisor_buf;
wire [8:0] sub_result = {remainder, quotient[7]} + {1'b0, ~divisor_abs} + 9'b1;
wire sub_negative = sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 4'b0;
        dividend_buf <= 8'b0;
        divisor_buf <= 8'b0;
        signed_op <= 1'b0;
        div_by_zero <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    // Buffer inputs and check for special cases
                    dividend_buf <= dividend;
                    divisor_buf <= divisor;
                    signed_op <= sign;
                    div_by_zero <= (divisor == 8'b0);
                    
                    if (dividend == 8'b0) begin
                        // Early termination for zero dividend
                        result <= 16'b0;
                        res_valid <= 1'b1;
                    end else if (divisor == 8'b0) begin
                        // Division by zero - encode special result
                        result <= {8'hFF, 8'hFF};
                        res_valid <= 1'b1;
                    end else begin
                        // Initialize calculation
                        divisor_abs <= signed_op & divisor[7] ? -divisor : divisor;
                        remainder <= 8'b0;
                        quotient <= signed_op & dividend[7] ? -dividend : dividend;
                        cnt <= 4'b0;
                        state <= CALCULATE;
                        res_valid <= 1'b0;
                    end
                end
            end
            
            CALCULATE: begin
                if (cnt == 8) begin
                    // Finalize result with sign correction if needed
                    if (signed_op) begin
                        remainder <= dividend_buf[7] ? -remainder : remainder;
                        quotient <= (dividend_buf[7] ^ divisor_buf[7]) ? -quotient : quotient;
                    end
                    
                    result <= {remainder, quotient};
                    res_valid <= 1'b1;
                    state <= IDLE;
                end else begin
                    // Perform one division step
                    remainder <= sub_negative ? 
                        {remainder[6:0], quotient[7]} : 
                        sub_result[7:0];
                    quotient <= sub_negative ? 
                        {quotient[6:0], 1'b0} : 
                        {quotient[6:0], 1'b1};
                    cnt <= cnt + 1;
                end
            end
        endcase
        
        // Clear valid flag when new operation starts
        if (opn_valid && res_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule