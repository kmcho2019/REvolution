module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result  // {remainder[15:8], quotient[7:0]}
);

reg [2:0] state; // 0:IDLE, 1:SIGN_PROC, 2:DIVIDE, 3:DONE
reg [3:0] cnt;
reg [15:0] partial; // {remainder, quotient}
reg [7:0] divisor_mag;
reg [7:0] dividend_mag;
reg result_sign;
wire [7:0] next_rem;
wire rem_ge_div;

// Parallel comparison logic
assign rem_ge_div = (partial[15:8] >= divisor_mag);
assign next_rem = rem_ge_div ? (partial[15:8] - divisor_mag) : partial[15:8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        cnt <= 0;
        partial <= 0;
        res_valid <= 0;
        result <= 0;
        divisor_mag <= 0;
        dividend_mag <= 0;
        result_sign <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                res_valid <= 0;
                if (opn_valid) begin
                    if (divisor == 0) begin // Handle division by zero
                        result <= 16'hFFFF;
                        res_valid <= 1;
                    end else begin
                        state <= 1; // Proceed to sign processing
                        cnt <= 0;
                    end
                end
            end
            
            1: begin // SIGN PROCESSING
                // Compute magnitudes and result sign
                dividend_mag <= sign & dividend[7] ? -dividend : dividend;
                divisor_mag <= sign & divisor[7] ? -divisor : divisor;
                result_sign <= sign & (dividend[7] ^ divisor[7]);
                
                // Initialize partial remainder
                partial <= {8'b0, dividend_mag};
                state <= 2; // Proceed to division
            end
            
            2: begin // DIVISION
                if (partial[15:8] == 0 && cnt != 0) begin // Early termination
                    state <= 3;
                end else if (cnt == 8) begin // Normal completion
                    state <= 3;
                end else begin
                    // Update partial remainder
                    partial <= {next_rem, partial[7:0], rem_ge_div};
                    cnt <= cnt + 1;
                end
            end
            
            3: begin // FINALIZE RESULT
                // Apply sign correction if needed
                if (result_sign) begin
                    result <= {partial[15:8], -partial[7:0]};
                end else begin
                    result <= partial;
                end
                res_valid <= 1;
                state <= 0; // Return to idle
            end
        endcase
    end
end

endmodule