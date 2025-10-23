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

reg [15:0] SR; // Shift register for dividend and quotient
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter for division steps
reg start_cnt; // Flag to indicate start of division
reg [7:0] remainder; // Final remainder
reg [7:0] quotient; // Final quotient
reg valid_result; // Flag to indicate result validity

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        valid_result <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize for a new operation
        SR <= {dividend[7], dividend}; // Shift dividend left by one bit
        if (sign) begin
            // Signed operation
            if (divisor[7]) begin
                NEG_DIVISOR <= ~({~divisor[7:0]} + 1);
            end else begin
                NEG_DIVISOR <= ~divisor;
            end
        end else begin
            // Unsigned operation
            NEG_DIVISOR <= ~divisor;
        end
        cnt <= 1;
        start_cnt <= 1;
        valid_result <= 0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            remainder <= SR[15:8];
            quotient <= SR[7:0];
            valid_result <= 1;
            res_valid <= 1;
            cnt <= 0;
        end else begin
            // Perform subtraction and update SR
            reg [15:0] sub_result;
            reg carry_out;
            if (SR[15:8] >= {8'd0, NEG_DIVISOR}) begin
                sub_result = SR[15:8] - {8'd0, NEG_DIVISOR};
                carry_out = 1;
            end else begin
                sub_result = SR[15:8];
                carry_out = 0;
            end
            SR <= {sub_result, carry_out, SR[7:1]}; // Shift SR left and insert carry_out
            cnt <= cnt + 1;
        end
    end else if (valid_result) begin
        // Result is valid, wait for consumption
        if (!opn_valid) begin
            res_valid <= 0;
            valid_result <= 0;
        end
    end
end

always @(*) begin
    if (valid_result) begin
        result = {remainder, quotient};
    end else begin
        result = 0;
    end
end

endmodule