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

reg [2:0] cnt;
reg [15:0] SR;  // {remainder, quotient}
reg running;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire quotient_sign = sign & (dividend[7] ^ divisor[7]);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        running <= 0;
    end else begin
        res_valid <= 0;  // Default clear
        
        if (!running) begin
            if (opn_valid && !res_valid) begin
                if (divisor == 0) begin
                    result <= {dividend, 8'hFF};  // Divide by zero
                    res_valid <= 1;
                end else begin
                    SR <= {8'b0, abs_dividend};
                    cnt <= 0;
                    running <= 1;
                end
            end
        end else begin
            if (cnt == 3'd7) begin
                // Final remainder adjustment
                if (SR[15]) SR[15:8] <= SR[15:8] + abs_divisor;
                
                // Apply sign correction
                result <= {
                    sign & dividend[7] ? -SR[15:8] : SR[15:8],
                    quotient_sign ? -SR[7:0] : SR[7:0]
                };
                res_valid <= 1;
                running <= 0;
            end else begin
                // Radix-2 division step
                SR <= ({SR[14:8], SR[7], 1'b0} < {1'b0, abs_divisor}) ?
                    {SR[14:8], SR[7:0], 1'b0} :  // No subtract
                    {SR[14:8], SR[7:0], 1'b0} - {abs_divisor, 8'b0} | 16'h0001;  // Subtract and set LSB
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule