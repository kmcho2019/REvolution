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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [15:0] SR; // Shift Register
reg [2:0] cnt; // Counter
reg start_cnt;
reg [15:0] final_result;

assign res_valid = (cnt == 8 && start_cnt) || (~rst && ~opn_valid && cnt != 0 && start_cnt);

always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        SR <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        final_result <= 0;
    end else if (opn_valid && ~res_valid) begin
        // Initialize values
        abs_dividend <= (sign) ? (dividend[7] ? (~dividend + 1) : dividend) : dividend;
        abs_divisor <= (sign) ? (divisor[7] ? (~divisor + 1) : divisor) : divisor;
        neg_divisor <= (~abs_divisor + 1);
        SR <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Update result
            final_result <= SR;
            start_cnt <= 0;
            cnt <= 0;
        end else begin
            // Compute subtraction and update SR
            reg [8:0] temp;
            temp <= {1'b0, SR[15:8]} - abs_divisor;
            if (temp[8]) begin // Carry-out
                SR <= {1'b0, SR[15:8]} - abs_divisor;
            end else begin
                SR <= {1'b1, SR[15:8]} - abs_divisor;
            end
            SR <= {SR[14:0], 1'b0} | {15'b0, temp[8]};
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
    end else if (res_valid) begin
        // Compute final quotient and remainder based on sign
        if (sign && (dividend[7] ^ divisor[7])) begin
            // Adjust for signed division
            result <= {~final_result[15:8] + 1, final_result[7:0]};
        end else begin
            result <= final_result;
        end
    end
end

endmodule