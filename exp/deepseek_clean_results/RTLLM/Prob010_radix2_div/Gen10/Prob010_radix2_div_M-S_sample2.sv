module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // {remainder, quotient}
);

reg [1:0] state; // 0: IDLE, 1: BUSY
reg [3:0] cnt;
reg [15:0] sr;   // shift register: {remainder, quotient}
reg [7:0] divisor_abs;
reg quotient_sign;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        divisor_abs <= 0;
        quotient_sign <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Handle sign and absolute values
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    
                    // Initialize shift register with absolute dividend
                    sr <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                    
                    state <= 1;
                    cnt <= 0;
                end
            end
            
            1: begin // BUSY
                if (divisor_abs == 0) begin // Division by zero
                    result <= 16'hFFFF;
                    res_valid <= 1;
                    state <= 0;
                end else if (cnt == 8) begin // Done
                    // Apply sign correction
                    result[15:8] <= quotient_sign[7] ? -sr[15:8] : sr[15:8];
                    result[7:0] <= quotient_sign ? -sr[7:0] : sr[7:0];
                    res_valid <= 1;
                    state <= 0;
                end else begin // Division step
                    // Subtract and shift
                    if (sr[15:8] >= divisor_abs) begin
                        sr <= {sr[15:8] - divisor_abs, sr[7:0], 1'b1};
                    end else begin
                        sr <= {sr[14:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule