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

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [8:0] sr; // Shift register
reg [8:0] neg_divisor; // Negated absolute value of the divisor
reg [3:0] cnt; // Counter
reg start_cnt; // Flag to start the division process
reg [15:0] temp_result;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        sr <= 0;
        neg_divisor <= 0;
    end else if (opn_valid && !res_valid) begin
        // Save the inputs
        saved_dividend <= dividend;
        saved_divisor <= divisor;
        
        // Initialize the shift register and NEG_DIVISOR
        if (sign) begin
            sr <= {1'b0, (saved_dividend[7]) ? (~saved_dividend + 1) : saved_dividend};
            neg_divisor <= (saved_divisor[7]) ? (~saved_divisor + 1) : saved_divisor;
        end else begin
            sr <= {1'b0, saved_dividend};
            neg_divisor <= {1'b0, saved_divisor};
        end
        
        // Set the counter and start_cnt
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Perform the division process
        if (cnt == 8) begin
            // Division is complete
            cnt <= 0;
            start_cnt <= 0;
            // Update the result
            temp_result <= {sr[8:1], sr[0]};
            res_valid <= 1;
        end else begin
            // Subtract NEG_DIVISOR from SR
            reg [8:0] temp_sr;
            temp_sr <= sr - neg_divisor;
            
            // Update SR based on the carry-out
            if (temp_sr[8]) begin
                sr <= {1'b1, temp_sr[7:0]} << 1;
            end else begin
                sr <= {1'b0, temp_sr[7:0]} << 1;
            end
            
            // Increment the counter
            cnt <= cnt + 1;
        end
    end else if (res_valid && !opn_valid) begin
        // Reset res_valid when the result is consumed
        res_valid <= 0;
    end
end

always @(*) begin
    result = temp_result;
end

endmodule