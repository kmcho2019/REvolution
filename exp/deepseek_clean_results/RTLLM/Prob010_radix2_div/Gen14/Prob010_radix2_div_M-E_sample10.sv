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

reg [15:0] working_reg;  // {remainder, quotient}
reg [7:0] abs_divisor;
reg [3:0] phase_counter;
reg result_negative;

wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_div = (sign & divisor[7]) ? -divisor : divisor;
wire [7:0] sub_value = working_reg[15:8] - abs_divisor;
wire subtraction_valid = ~sub_value[7];  // No borrow means divisor <= remainder

always @(posedge clk or posedge rst) begin
    if (rst) begin
        working_reg <= 16'b0;
        phase_counter <= 4'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        // Default assignments
        res_valid <= 1'b0;

        // Operation phases
        if (phase_counter == 0) begin
            // Phase 0: Initialization
            if (opn_valid && !res_valid) begin
                if (divisor == 0) begin
                    // Handle divide by zero
                    result <= {dividend, 8'hFF};
                    res_valid <= 1'b1;
                end else begin
                    // Initialize working registers
                    working_reg <= {8'b0, abs_dividend};
                    abs_divisor <= abs_div;
                    result_negative <= sign & (dividend[7] ^ divisor[7]);
                    phase_counter <= 4'b1;
                end
            end
        end else begin
            // Phase 1-8: Computation
            if (!phase_counter[3]) begin  // Continue until counter reaches 8
                // Perform one division step
                working_reg <= subtraction_valid ? 
                    {sub_value[6:0], working_reg[7:0], 1'b1} : 
                    {working_reg[14:0], 1'b0};
                
                phase_counter <= phase_counter + 1;
            end else begin
                // Phase 9: Finalization
                result <= {
                    (sign & dividend[7]) ? -working_reg[15:8] : working_reg[15:8],
                    result_negative ? -working_reg[7:0] : working_reg[7:0]
                };
                res_valid <= 1'b1;
                phase_counter <= 0;
            end
        end
    end
end

endmodule