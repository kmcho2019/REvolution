module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]    dividend,
    input   [7:0]    divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]   result
);

// Internal signals
reg     [15:0]   sr;      // Shift register
reg     [7:0]    neg_divisor;  // Negated absolute value of the divisor
reg     [2:0]    cnt;     // Counter
reg             start_cnt;  // Start counter flag
reg             res_valid_reg;  // Result validity flag

// Absolute values of dividend and divisor
wire    [7:0]    abs_dividend;
assign abs_dividend = sign ? (~dividend + 1) : dividend;

wire    [7:0]    abs_divisor;
assign abs_divisor = sign ? (~divisor + 1) : divisor;

// Subtraction result
wire    [8:0]    sub_result;
assign sub_result = {1'b0, sr[7:0]} - {1'b0, neg_divisor};

// Carry-out from subtraction
wire            carry_out;
assign carry_out = sub_result[8];

// Initial values
initial begin
    sr = 16'h0000;
    neg_divisor = 8'h00;
    cnt = 3'h0;
    start_cnt = 1'b0;
    res_valid_reg = 1'b0;
end

always @(posedge clk) begin
    if (rst) begin
        sr = 16'h0000;
        neg_divisor = 8'h00;
        cnt = 3'h0;
        start_cnt = 1'b0;
        res_valid_reg = 1'b0;
    end else if (opn_valid && !res_valid_reg) begin
        // Save inputs and initialize shift register
        sr = {8'h00, abs_dividend};
        neg_divisor = ~abs_divisor + 1;
        cnt = 3'h1;
        start_cnt = 1'b1;
        res_valid_reg = 1'b0;
    end else if (start_cnt) begin
        if (cnt == 3'h8) begin
            // Division complete
            cnt = 3'h0;
            start_cnt = 1'b0;
            sr = {8'h00, sr[7:0]};
            res_valid_reg = 1'b1;
        end else begin
            // Update shift register and counter
            sr = {carry_out, sr[14:1]};
            cnt = cnt + 1;
        end
    end else if (res_valid_reg && !opn_valid) begin
        // Reset result validity flag
        res_valid_reg = 1'b0;
    end
end

assign res_valid = res_valid_reg;
assign result = sign ? (sr[15] ? {8'hff, ~sr[7:0] + 1} : sr) : sr;

endmodule