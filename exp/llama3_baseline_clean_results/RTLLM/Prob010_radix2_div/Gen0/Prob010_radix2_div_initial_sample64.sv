module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR; // Shift register to hold the dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the division steps
reg start_cnt; // Flag to indicate the start of the division process
reg [7:0] abs_dividend; // Absolute value of the dividend
reg [7:0] abs_divisor; // Absolute value of the divisor
reg is_signed; // Flag to indicate signed or unsigned operation

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize variables
        abs_dividend <= sign ? (~dividend + 1) : dividend;
        abs_divisor <= sign ? (~divisor + 1) : divisor;
        SR <= {1'b0, abs_dividend};
        NEG_DIVISOR <= ~abs_divisor + 1;
        start_cnt <= 1'b1;
        cnt <= 3'b001;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 3'b100) begin
            // Division complete, update result and reset flags
            result <= {SR[7:0], SR[7:0]};
            res_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 3'b000;
        end else begin
            // Update shift register and counter
            reg [8:0] temp;
            temp <= SR - abs_divisor;
            if (temp[8]) begin
                // No borrow, insert 0 and shift left
                SR <= {1'b0, SR[7:1]};
            end else begin
                // Borrow, insert 1 and shift left
                SR <= {1'b1, SR[7:1]};
            end
            cnt <= cnt + 1'b1;
        end
    end else if (res_valid) begin
        // Reset result validity when consumed
        res_valid <= 1'b0;
    end
end

endmodule