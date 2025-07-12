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

reg [7:0] saved_dividend;
reg [7:0] saved_divisor;
reg [15:0] sr;  // Shift register
reg [7:0] neg_divisor;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter
reg start_cnt;  // Flag to start the division process
reg [15:0] final_result;  // Final result (remainder and quotient)
reg prev_opn_valid;  // Previous value of opn_valid
reg prev_res_valid;  // Previous value of res_valid

// Combinatorial logic for subtraction and result update
wire [8:0] subtract_result;
assign subtract_result = {1'b0, sr[7:0]} - neg_divisor;

// Sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers and flags
        saved_dividend <= 8'b0;
        saved_divisor <= 8'b0;
        sr <= 16'b0;
        neg_divisor <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        prev_opn_valid <= 1'b0;
        prev_res_valid <= 1'b0;
    end else begin
        // Save inputs and initialize flags
        if (opn_valid && !prev_opn_valid && !res_valid) begin
            saved_dividend <= sign ? -dividend[7:0] : dividend[7:0];
            saved_divisor <= divisor[7:0];
            sr <= {1'b0, saved_dividend[7:0]} << 1;
            neg_divisor <= -saved_divisor[7:0];
            cnt <= 1'b1;
            start_cnt <= 1'b1;
        end

        // Division process
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete, update result and reset flags
                final_result <= {sr[15:8], sr[7:0]};
                result <= final_result;
                res_valid <= 1'b1;
                cnt <= 3'b0;
                start_cnt <= 1'b0;
            end else begin
                // Update shift register and increment counter
                if (subtract_result[8]) begin
                    sr <= {1'b1, sr[15:1]};
                end else begin
                    sr <= {1'b0, sr[15:1]} + subtract_result[7:0];
                end
                cnt <= cnt + 1'b1;
            end
        end

        // Manage result validity
        if (res_valid && !prev_res_valid) begin
            // Result is valid, wait for it to be consumed
        end
        if (rst) begin
            res_valid <= 1'b0;
        end

        // Update previous values
        prev_opn_valid <= opn_valid;
        prev_res_valid <= res_valid;
    end
end

endmodule