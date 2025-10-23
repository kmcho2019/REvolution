module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Internal registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] shift_reg;  // Shift register for division
reg [3:0] cnt;         // Counter for division steps
reg start_cnt;        // Flag to start division

// Reset all signals to default values
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else begin
        // Check for new operation and handle division by zero
        if (opn_valid && !res_valid && divisor != 0) begin
            // Save inputs and initialize internal signals
            dividend_reg <= sign ? { {7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
            divisor_reg <= sign ? { {7{divisor[7]}}, divisor[7:0]} : divisor;
            shift_reg <= {8'b0, dividend_reg};  // Initialize shift register
            cnt <= 1;
            start_cnt <= 1;
        end

        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result and reset signals
                result <= {shift_reg[15:8], shift_reg[7:0]};  // Upper 8 bits are remainder, lower 8 bits are quotient
                res_valid <= 1;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                // Perform division step
                reg [8:0] temp;
                temp = {1'b0, shift_reg[15:8]} - divisor_reg;
                if (temp[8]) begin
                    shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                end else begin
                    shift_reg <= {temp[7:0], 1'b1, shift_reg[7:1]};
                end
                cnt <= cnt + 1;
            end
        end

        // Reset result valid when operation is not valid or reset is asserted
        if (!opn_valid && res_valid || rst) begin
            res_valid <= 0;
        end
    end
end

endmodule