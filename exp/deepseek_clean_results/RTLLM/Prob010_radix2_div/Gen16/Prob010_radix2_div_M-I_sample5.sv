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

reg [7:0] dividend_abs, divisor_abs;
reg quotient_sign;
reg [2:0] cnt;  // Reduced from 4 to 3 bits since we only count to 8
reg [15:0] SR;  // {remainder, quotient}
reg running;

wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};
wire division_done = (cnt == 3'd7) && running;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        running <= 0;
        SR <= 0;
    end else begin
        res_valid <= 0;  // Default assignment
        
        if (opn_valid && !running && !res_valid) begin
            // Handle input processing and sign calculation in one step
            dividend_abs <= sign & dividend[7] ? -dividend : dividend;
            divisor_abs <= sign & divisor[7] ? -divisor : divisor;
            quotient_sign <= sign & (dividend[7] ^ divisor[7]);
            
            if (divisor == 0) begin
                // Immediate result for divide by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize division registers
                SR <= {8'b0, dividend_abs};
                cnt <= 0;
                running <= 1;
            end
        end else if (running) begin
            if (division_done) begin
                // Final remainder adjustment (non-restoring)
                if (SR[15]) SR[15:8] <= SR[15:8] + divisor_abs;
                
                // Apply sign correction to final result
                result <= {
                    sign & dividend[7] ? -SR[15:8] : SR[15:8],
                    quotient_sign ? -SR[7:0] : SR[7:0]
                };
                res_valid <= 1;
                running <= 0;
            end else begin
                // Radix-2 division step
                SR <= sub_result[8] ? 
                    {sub_result[7:0], SR[7:1], 1'b0} : 
                    {sub_result[7:0], SR[7:1], 1'b1};
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule