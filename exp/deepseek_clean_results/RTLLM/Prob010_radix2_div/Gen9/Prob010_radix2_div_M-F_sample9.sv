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

reg [2:0] state;
reg [3:0] cnt;       // Expanded to 4 bits to check MSB for cnt==8
reg [16:0] sr;       // Expanded shift register: 1 extra bit for carry
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;

localparam IDLE = 0;
localparam CALCULATE = 1;
localparam DONE = 2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Store signs and absolute values
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    dividend_abs <= (sign & dividend[7]) ? -dividend : dividend;
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    div_by_zero <= (divisor == 0);
                    
                    // Initialize shift register (shifted left by 1 as specified)
                    sr <= {8'b0, dividend_abs, 1'b0};
                    cnt <= 0;
                    state <= div_by_zero ? DONE : CALCULATE;
                end
            end
            
            CALCULATE: begin
                if (cnt[3]) begin  // Check MSB for cnt==8
                    state <= DONE;
                end else begin
                    // Perform one division step
                    if (sr[16:9] >= divisor_abs) begin
                        sr <= {sr[16:9] - divisor_abs, sr[8:0], 1'b1};
                    end else begin
                        sr <= {sr[16:9], sr[8:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                res_valid <= 1;
                if (div_by_zero) begin
                    result <= 16'hFFFF;  // Distinct error pattern
                end else begin
                    // Apply sign correction and pack result
                    result <= {
                        dividend_sign ? -sr[16:9] : sr[16:9],  // remainder
                        (dividend_sign ^ divisor_sign) ? -sr[8:1] : sr[8:1]  // quotient
                    };
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule