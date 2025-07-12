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

reg [7:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter flag
reg [15:0] temp_result; // Temporary result register
reg prev_opn_valid; // Previous operation valid flag

// Initialize on reset or new operation request
always @(posedge clk) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        prev_opn_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        // Initialize shift register with absolute dividend shifted left
        SR <= {1'b0, (sign ? (~dividend[7] + 1) : dividend)};
        // Initialize negated divisor
        NEG_DIVISOR <= (~divisor[7] + 1);
        cnt <= 1;
        start_cnt <= 1;
        prev_opn_valid <= 1;
    end else if (opn_valid && prev_opn_valid) begin
        // No action when opn_valid is continuously high
    end else begin
        prev_opn_valid <= opn_valid;
    end
end

// Perform division iterations
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result
            temp_result <= {SR[7:0], SR[7:0]};
            res_valid <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            // Update shift register based on subtraction
            if (SR[7] == 1'b0) begin
                // No borrow, shift left and insert 0
                SR <= {SR[6:0], 1'b0};
            end else begin
                // Borrow, shift left and insert 1
                SR <= {SR[6:0], 1'b1};
            end
            cnt <= cnt + 1;
        end
    end
end

// Update result and validity
always @(posedge clk) begin
    if (rst) begin
        result <= 0;
    end else if (res_valid) begin
        result <= temp_result;
    end
end

// Clear result validity on reset or result consumption
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule