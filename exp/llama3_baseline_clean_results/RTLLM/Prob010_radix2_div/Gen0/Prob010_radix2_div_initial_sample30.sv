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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start division
reg [15:0] temp_result; // Temporary result
reg [7:0] quotient; // Quotient
reg [7:0] remainder; // Remainder
reg valid; // Flag to indicate result validity

always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        valid <= 0;
    end else if (opn_valid &&!valid) begin
        // Save inputs and initialize variables
        SR <= {1'b0, dividend}; // Shift dividend left by one bit
        if (sign) begin
            NEG_DIVISOR <= ~divisor + 1; // Two's complement
        end else begin
            NEG_DIVISOR <= ~divisor + 1; // Two's complement for unsigned
        end
        cnt <= 1;
        start_cnt <= 1;
        valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            quotient <= SR[7:0];
            remainder <= SR[15:8];
            temp_result <= {remainder, quotient};
            valid <= 1;
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            // Perform division step
            if (SR[15] == 1'b0) begin
                // No borrow
                SR <= {SR[14:0], 1'b0}; // Shift left and insert 0
            end else begin
                // Borrow
                SR <= SR + NEG_DIVISOR;
                SR <= {SR[14:0], 1'b1}; // Shift left and insert 1
            end
            cnt <= cnt + 1;
        end
    end else if (valid &&!opn_valid) begin
        // Result consumed, reset valid flag
        valid <= 0;
    end
end

assign res_valid = valid;
assign result = temp_result;

endmodule