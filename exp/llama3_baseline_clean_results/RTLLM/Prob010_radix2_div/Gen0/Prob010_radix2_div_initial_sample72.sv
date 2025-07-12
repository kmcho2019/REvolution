module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

    reg [7:0] SR_Q;  // quotient part of the result
    reg [7:0] SR_R;  // remainder part of the result
    reg [7:0] NEG_DIVISOR;  // negated absolute value of the divisor
    reg [2:0] cnt;  // counter for division process
    reg start_cnt;  // flag to start the division process

    // Synchronize operation with the clock signal
    always @(posedge clk) begin
        if (rst) begin  // reset signal
            res_valid <= 1'b0;
            cnt <= 3'b000;
            start_cnt <= 1'b0;
            SR_Q <= 8'b0;
            SR_R <= 8'b0;
        end else if (opn_valid && !res_valid) begin  // operation request
            // save inputs
            reg [7:0] div_temp;
            reg [7:0] divs_temp;
            if (sign) begin  // signed division
                div_temp = (dividend[7] == 1'b0) ? dividend : ~dividend + 8'b1;
                divs_temp = (divisor[7] == 1'b0) ? divisor : ~divisor + 8'b1;
            end else begin  // unsigned division
                div_temp = dividend;
                divs_temp = divisor;
            end
            SR_R <= {1'b0, div_temp};  // initialize shift register
            NEG_DIVISOR <= ~divs_temp + 8'b1;  // negated absolute value of divisor
            cnt <= 3'b001;  // initialize counter
            start_cnt <= 1'b1;  // start division process
        end else if (start_cnt) begin  // division process
            reg [8:0] temp_sub;  // temporary result for subtraction
            if (cnt == 3'b100) begin  // most significant bit of counter set
                start_cnt <= 1'b0;  // end division process
                cnt <= 3'b000;  // clear counter
                // update result
                if (sign) begin  // signed division
                    if (dividend[7] != divisor[7]) begin  // different signs
                        SR_Q <= ~SR_Q + 8'b1;  // adjust quotient for sign
                    end
                end
                result <= {SR_R, SR_Q};  // update result
                res_valid <= 1'b1;  // set result validity
            end else begin
                temp_sub = {1'b0, SR_R} - NEG_DIVISOR;  // subtraction
                if (temp_sub[8]) begin  // carry-out of subtraction
                    SR_R <= SR_R << 1;  // shift left without inserting carry-out
                end else begin
                    SR_R <= {temp_sub[7], SR_R[7:1]} + 8'b1;  // shift left and insert carry-out
                    SR_Q <= SR_Q + 8'b1;  // increment quotient
                end
                cnt <= cnt + 1;  // increment counter
            end
        end
        if (res_valid) begin  // result consumed
            res_valid <= 1'b0;
        end
    end

endmodule