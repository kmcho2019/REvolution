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

    reg [7:0] sr; // Shift register to hold the dividend and quotient
    reg [7:0] neg_divisor; // Negated absolute value of the divisor
    reg [3:0] cnt; // Counter to track the division steps
    reg start_cnt; // Flag to indicate the start of the division
    reg [15:0] temp_result; // Temporary result
    reg result_valid; // Internal signal to track result validity

    // Combinational logic to compute the subtraction result
    wire [8:0] subtraction_result;
    assign subtraction_result = {1'b0, sr} - {8'b0, neg_divisor};

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all signals
            sr <= 0;
            neg_divisor <= 0;
            cnt <= 0;
            start_cnt <= 0;
            result_valid <= 0;
            res_valid <= 0;
        end else if (opn_valid && !res_valid) begin
            // Operation start
            if (sign) begin
                // Signed division
                sr <= ({8'b0, dividend[7]} == 1'b1) ? (~{8'b0, dividend} + 1'b1) : {8'b0, dividend};
                neg_divisor <= (~divisor + 1'b1);
            end else begin
                // Unsigned division
                sr <= {8'b0, dividend};
                neg_divisor <= ~divisor + 1'b1;
            end
            cnt <= 1;
            start_cnt <= 1'b1;
            result_valid <= 1'b0;
            res_valid <= 1'b0;
        end else if (start_cnt) begin
            // Division process
            if (cnt == 8'd8) begin
                // Division complete
                cnt <= 0;
                start_cnt <= 1'b0;
                if (sign) begin
                    // Correct the quotient and remainder for signed division
                    if (dividend[7] == 1'b1 && divisor[7] == 1'b0) begin
                        // Negative dividend and positive divisor
                        temp_result <= {sr[7:0], ~sr[7:0] + 1'b1};
                    end else if (dividend[7] == 1'b0 && divisor[7] == 1'b1) begin
                        // Positive dividend and negative divisor
                        temp_result <= {sr[7:0], ~sr[7:0] + 1'b1};
                    end else begin
                        // Both positive or both negative
                        temp_result <= {sr[7:0], sr[7:0]};
                    end
                end else begin
                    temp_result <= {sr[7:0], sr[7:0]};
                end
                result_valid <= 1'b1;
            end else begin
                // Update shift register and counter
                if (subtraction_result[8]) begin
                    // Carry-out, set least significant bit of quotient to 1
                    sr <= {subtraction_result[7:0], 1'b1};
                end else begin
                    // No carry-out, set least significant bit of quotient to 0
                    sr <= {subtraction_result[7:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end

        if (result_valid && !res_valid) begin
            res_valid <= 1'b1;
            result <= temp_result;
        end

        if (rst || !opn_valid) begin
            result_valid <= 1'b0;
        end
    end

endmodule