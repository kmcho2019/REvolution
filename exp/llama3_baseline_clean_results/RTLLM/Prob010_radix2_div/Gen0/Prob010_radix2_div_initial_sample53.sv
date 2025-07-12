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

reg [7:0] SR; // Shift Register to hold the dividend
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the number of division steps
reg start_cnt; // Flag to indicate the start of division

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        SR <= 8'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            SR <= {1'b0, (sign) ? (~dividend[7] ? dividend : ~dividend + 1) : dividend}; // Save dividend and shift left by 1 bit
            NEG_DIVISOR <= (sign) ? (~divisor[7] ? divisor : ~divisor + 1) : divisor; // Save negated absolute value of divisor
            cnt <= 1; // Initialize counter
            start_cnt <= 1'b1; // Start division process
        end
        
        if (start_cnt) begin
            if (cnt == 8'd8) begin
                // Division complete, update result
                result <= {SR[7:0], SR[7:0]}; // Combine remainder and quotient
                res_valid <= 1'b1;
                cnt <= 3'd0;
                start_cnt <= 1'b0;
            end else begin
                // Perform subtraction and update SR based on carry-out
                reg [8:0] sub_result;
                sub_result = {1'b0, SR} - NEG_DIVISOR;
                
                if (sub_result[8]) begin
                    // If carry-out is 1, update SR with borrow
                    SR <= {1'b1, SR[7:1]};
                end else begin
                    // If carry-out is 0, update SR without borrow
                    SR <= {1'b0, SR[7:1]} + sub_result[7:0];
                end
                
                cnt <= cnt + 1; // Increment counter
            end
        end
        
        if (rst || !opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule