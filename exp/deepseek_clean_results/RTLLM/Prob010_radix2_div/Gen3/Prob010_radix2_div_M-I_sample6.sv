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

// State encoding
localparam IDLE = 1'b0;
localparam BUSY = 1'b1;

reg state;
reg [2:0] cnt;  // Reduced from 4 to 3 bits since we only count to 8
reg signed_op;
reg div_by_zero;

// Working registers
reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] divisor_mag;

// Pre-processed inputs
wire [7:0] dividend_mag = (signed_op & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs = (signed_op & divisor[7]) ? -divisor : divisor;

// Subtraction logic with carry lookahead
wire [8:0] sub_add = {remainder, quotient[7]} + {1'b0, ~divisor_mag} + 9'b1;
wire sub_neg = sub_add[8];
wire [7:0] sub_res = sub_add[7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 3'b0;
        signed_op <= 1'b0;
        div_by_zero <= 1'b0;
    end else begin
        res_valid <= 1'b0;  // Default unless we set it
        
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    signed_op <= sign;
                    div_by_zero <= (divisor == 8'b0);
                    
                    if (dividend == 8'b0) begin
                        // Zero dividend special case
                        result <= 16'b0;
                        res_valid <= 1'b1;
                    end else if (divisor == 8'b0) begin
                        // Division by zero - encode as all 1s
                        result <= {8'hFF, 8'hFF};
                        res_valid <= 1'b1;
                    end else begin
                        // Initialize calculation
                        divisor_mag <= divisor_abs;
                        remainder <= 8'b0;
                        quotient <= dividend_mag;
                        cnt <= 3'b0;
                        state <= BUSY;
                    end
                end
            end
            
            BUSY: begin
                if (cnt == 3'd7) begin
                    // Finalize result with sign correction
                    if (signed_op) begin
                        remainder <= (dividend[7]) ? -remainder : remainder;
                        quotient <= (dividend[7] ^ divisor[7]) ? -quotient : quotient;
                    end
                    
                    result <= {remainder, quotient};
                    res_valid <= 1'b1;
                    state <= IDLE;
                end else begin
                    // Radix-2 division step
                    if (!sub_neg) begin
                        remainder <= sub_res;
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        remainder <= {remainder[6:0], quotient[7]};
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule