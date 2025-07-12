module radix2_div(
    input clk,        // Clock signal
    input rst,        // Reset signal
    input sign,       // Signed (1) or unsigned (0) division
    input [7:0] dividend,  // Dividend
    input [7:0] divisor,   // Divisor
    input opn_valid,      // Operation valid
    output res_valid,     // Result valid
    output [15:0] result  // Result (quotient and remainder)
);

reg [7:0] sr;          // Shift register
reg [7:0] neg_divisor; // Negated divisor
reg [3:0] cnt;         // Counter
reg start_cnt;        // Start counter
reg [7:0] q;           // Quotient
reg [7:0] r;           // Remainder
reg valid_result;     // Valid result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all signals
        sr <= 8'd0;
        neg_divisor <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'd0;
        q <= 8'd0;
        r <= 8'd0;
        valid_result <= 1'd0;
        res_valid <= 1'd0;
    end else if (~opn_valid || res_valid) begin
        // Do nothing if operation is not valid or result is already valid
    end else begin
        // Save inputs when operation is valid
        sr <= {1'd0, dividend};
        neg_divisor <= ~divisor + 1;
        cnt <= 4'd1;
        start_cnt <= 1'd1;
        valid_result <= 1'd0;
        res_valid <= 1'd0;
    end
end

always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8'd8) begin
            // Division complete
            start_cnt <= 1'd0;
            res_valid <= 1'd1;
            valid_result <= 1'd1;
            result <= {r, q};
        end else begin
            // Perform division
            reg [8:0] temp;
            temp <= sr - neg_divisor;
            if (temp[8]) begin
                // No borrow, shift in 0
                sr <= {1'd0, sr[7:1]};
                q <= {q[6:0], 1'd0};
            end else begin
                // Borrow, shift in 1
                sr <= {1'd1, sr[7:1]};
                q <= {q[6:0], 1'd1};
            end
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (valid_result) begin
        r <= sr[7:0];
    end
end

endmodule