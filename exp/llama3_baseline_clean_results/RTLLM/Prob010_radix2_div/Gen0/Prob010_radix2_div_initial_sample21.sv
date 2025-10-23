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

reg [15:0] SR; // Shift register to hold the remainder and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the division process
reg start_cnt; // Flag to indicate the start of the division process

always @ (posedge clk) begin
    if (rst) begin
        // Reset all registers
        res_valid <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save the inputs and initialize the registers
            if (sign) begin
                // Signed division
                SR <= {8'b0, dividend[7] ? (~dividend + 1) : dividend};
            end else begin
                // Unsigned division
                SR <= {8'b0, dividend};
            end
            NEG_DIVISOR <= divisor[7] ? (~divisor + 1) : divisor;
            cnt <= 1;
            start_cnt <= 1;
        end

        if (start_cnt) begin
            if (cnt == 8) begin
                // Division is complete
                cnt <= 0;
                start_cnt <= 0;
                res_valid <= 1;
                result <= {SR[15:8], SR[7:0]};
            end else begin
                // Update the shift register and counter
                reg [8:0] temp;
                temp = {1'b0, SR[15:8]} - {NEG_DIVISOR, 3'b000};
                SR <= {temp[8], temp[7:0], 1'b0};
                cnt <= cnt + 1;
            end
        end

        if (res_valid && !opn_valid) begin
            // Result has been consumed, reset the valid flag
            res_valid <= 0;
        end
    end
end

endmodule