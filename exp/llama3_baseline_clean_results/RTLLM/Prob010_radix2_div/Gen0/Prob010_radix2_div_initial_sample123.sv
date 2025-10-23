module radix2_div(
    input             clk,        // Clock signal
    input             rst,        // Reset signal
    input      [0:0]  sign,      // Signed or unsigned operation
    input      [7:0]  dividend,  // Dividend
    input      [7:0]  divisor,   // Divisor
    input      [0:0]  opn_valid, // Operation valid
    output reg [0:0]  res_valid, // Result valid
    output reg [15:0] result     // Result (remainder and quotient)
);

reg  [8:0]  sr;         // Shift register
reg  [7:0]  neg_divisor; // Negated divisor
reg  [2:0]  cnt;        // Counter
reg  [0:0]  start_cnt;  // Start counter
reg  [7:0]  abs_dividend; // Absolute value of dividend
reg  [7:0]  abs_divisor;  // Absolute value of divisor
reg  [0:0]  sign_dividend; // Sign of dividend
reg  [0:0]  sign_divisor;  // Sign of divisor

// Initialize absolute values and signs
always @(posedge clk) begin
    if (rst) begin
        abs_dividend  <= 8'd0;
        abs_divisor   <= 8'd0;
        sign_dividend <= 1'd0;
        sign_divisor  <= 1'd0;
    end else if (opn_valid &&!res_valid) begin
        abs_dividend  <= (sign[0] && dividend[7])? (~dividend + 1'd1) : dividend;
        abs_divisor   <= (sign[0] && divisor[7]) ? (~divisor + 1'd1)  : divisor;
        sign_dividend <= (sign[0] && dividend[7])? 1'd1 : 1'd0;
        sign_divisor  <= (sign[0] && divisor[7]) ? 1'd1 : 1'd0;
    end
end

// Initialize shift register, negated divisor, and counter
always @(posedge clk) begin
    if (rst) begin
        sr         <= 9'd0;
        neg_divisor <= 8'd0;
        cnt         <= 3'd0;
        start_cnt   <= 1'd0;
    end else if (opn_valid &&!res_valid) begin
        sr         <= {1'd0, abs_dividend}; // Initialize shift register
        neg_divisor <= ~abs_divisor + 1'd1; // Initialize negated divisor
        cnt         <= 3'd1; // Initialize counter
        start_cnt   <= 1'd1; // Start counter
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8'd8) begin // Division complete
            cnt         <= 3'd0;
            start_cnt   <= 1'd0;
            // Update result
            result      <= {sr[8:1], sr[0:0]};
            if (sign[0] && ((sign_dividend ^ sign_divisor))) begin
                result <= {~result[15:8] + 1'd1, ~result[7:0] + 1'd1};
            end
        end else begin
            reg [8:0] subtraction;
            subtraction <= sr - {1'd0, neg_divisor};
            if (subtraction[8]) begin
                sr <= {1'd1, sr[7:0]};
            end else begin
                sr <= {1'd0, sr[7:0]} + {8'd0, ~subtraction[8]};
            end
            cnt <= cnt + 1'd1;
        end
    end
end

// Result validity
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'd0;
    end else if (cnt == 8'd8) begin
        res_valid <= 1'd1;
    end else if (opn_valid &&!res_valid) begin
        res_valid <= 1'd0;
    end
end

endmodule