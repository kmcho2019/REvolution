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

// Internal signals
reg [8:0] SR;  // Shift register
reg [8:0] NEG_DIVISOR;  // Negated absolute value of divisor
reg [3:0] cnt;  // Counter
reg start_cnt;  // Start counter flag

// Initial values
initial begin
    res_valid = 1'b0;
    result = 16'd0;
    SR = 9'd0;
    NEG_DIVISOR = 9'd0;
    cnt = 4'd0;
    start_cnt = 1'b0;
end

// Clock edge detection
always @(posedge clk) begin
    if (rst) begin
        // Reset logic
        res_valid <= 1'b0;
        result <= 16'd0;
        SR <= 9'd0;
        NEG_DIVISOR <= 9'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
    end
    else if (opn_valid && !res_valid) begin
        // Operation start
        SR <= {1'b0, dividend[7:0]} << 1;  // Initialize SR with absolute value of dividend
        if (sign) begin
            NEG_DIVISOR <= -divisor[7:0];  // Negated absolute value of divisor for signed division
        end
        else begin
            NEG_DIVISOR <= ~divisor[7:0] + 1;  // Negated absolute value of divisor for unsigned division
        end
        cnt <= 1;  // Initialize counter
        start_cnt <= 1'b1;  // Set start counter flag
    end
    else if (start_cnt) begin
        // Division process
        if (cnt == 8'd8) begin
            // Division complete
            start_cnt <= 1'b0;  // Clear start counter flag
            cnt <= 4'd0;  // Clear counter
            if (sign) begin
                result <= {SR[8:1], 8'd0};  // Final result for signed division
            end
            else begin
                result <= {SR[8:1], SR[0]} << 8;  // Final result for unsigned division
            end
            res_valid <= 1'b1;  // Set result valid flag
        end
        else begin
            // Update SR and counter
            reg [9:0] temp;  // Temporary variable for subtraction
            temp = SR + NEG_DIVISOR;
            if (temp[9]) begin
                // No borrow
                SR <= {1'b0, SR[7:0]} << 1;  // Shift SR left
            end
            else begin
                // Borrow
                SR <= {1'b1, SR[7:0]} << 1;  // Shift SR left with borrow
            end
            cnt <= cnt + 1;  // Increment counter
        end
    end
    else if (res_valid) begin
        // Result validity management
        if (!opn_valid) begin
            res_valid <= 1'b0;  // Clear result valid flag
        end
    end
end

endmodule