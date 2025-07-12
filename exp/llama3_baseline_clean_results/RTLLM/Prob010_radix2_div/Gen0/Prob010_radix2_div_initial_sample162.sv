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

reg [7:0] abs_dividend, abs_divisor, neg_divisor;
reg [7:0] shift_register;
reg [7:0] cnt;
reg start_cnt;

always @(posedge clk) begin
    if(rst) begin
        res_valid <= 0;
        start_cnt <= 0;
        cnt <= 0;
        shift_register <= 0;
    end else if(opn_valid && !res_valid) begin
        // Save inputs
        if(sign) begin
            abs_dividend <= dividend[7] ? -dividend : dividend;
            abs_divisor <= divisor[7] ? -divisor : divisor;
        end else begin
            abs_dividend <= dividend;
            abs_divisor <= divisor;
        end
        neg_divisor <= ~abs_divisor + 1;
        // Initialize shift register with absolute value of dividend shifted left by one bit
        shift_register <= {1'b0, abs_dividend};
        start_cnt <= 1;
        cnt <= 1;
    end else if(start_cnt) begin
        // Division process
        if(cnt == 8) begin
            // Division complete, update result
            if(sign) begin
                if((dividend[7] ^ divisor[7]) && (shift_register[7])) begin
                    result <= {shift_register[7:0], shift_register[7:0] - abs_divisor};
                end else begin
                    result <= {shift_register[7:0], shift_register[7:0]};
                end
            end else begin
                result <= {shift_register[7:0], shift_register[7:0]};
            end
            res_valid <= 1;
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            // Update shift register based on subtraction result
            reg [8:0] subtraction_result;
            subtraction_result <= {1'b0, shift_register} - {1'b0, neg_divisor};
            if(subtraction_result[8]) begin
                // No borrow, shift in 1
                shift_register <= {1'b1, shift_register[7:1]};
            end else begin
                // Borrow, shift in 0
                shift_register <= {1'b0, shift_register[7:1]};
            end
            cnt <= cnt + 1;
        end
    end else begin
        if(res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule