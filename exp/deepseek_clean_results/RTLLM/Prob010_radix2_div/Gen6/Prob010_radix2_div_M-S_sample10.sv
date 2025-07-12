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

reg [3:0] cnt;
reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [7:0] divisor_abs;
reg start_div;
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_twos_comp = -divisor_abs;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, divisor_twos_comp};
wire carry_out = ~sub_result[8];  // Positive result means no borrow
wire [15:0] next_SR = carry_out ? {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        start_div <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Start new division
            SR <= {8'b0, dividend_abs, 1'b0};
            divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
            cnt <= 0;
            start_div <= 1;
            res_valid <= 0;
        end else if (start_div) begin
            if (cnt == 8) begin
                // Division complete
                start_div <= 0;
                res_valid <= 1;
                if (divisor == 0) begin
                    result <= {8'hFF, 8'hFF}; // Divide by zero
                end else begin
                    // Apply sign correction
                    result <= {
                        (sign & dividend[7]) ? -SR[15:8] : SR[15:8],
                        ((sign & dividend[7]) ^ (sign & divisor[7])) ? -SR[7:0] : SR[7:0]
                    };
                end
            end else begin
                // Continue division
                SR <= next_SR;
                cnt <= cnt + 1;
            end
        end else if (res_valid && opn_valid) begin
            // Ready for new operation
            res_valid <= 0;
        end
    end
end

endmodule