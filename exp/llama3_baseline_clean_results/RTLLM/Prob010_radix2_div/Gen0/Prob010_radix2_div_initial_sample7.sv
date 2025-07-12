module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Internal signals
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [8:0] neg_divisor;
reg [8:0] sr;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg [7:0] remainder;
reg carry_out;

// Initialize signals
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        abs_dividend <= (sign)? (~dividend + 1) : dividend;
        abs_divisor <= (sign)? (~divisor + 1) : divisor;
        neg_divisor <= (~abs_divisor + 1);
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            start_cnt <= 0;
            remainder <= sr[8:1];
            quotient <= sr[0];
            res_valid <= 1;
        end else begin
            // Update shift register
            carry_out <= (sr[8:1] < neg_divisor)? 1'b1 : 1'b0;
            sr <= {carry_out, sr[8:1]} + (carry_out? 0 : neg_divisor);
            cnt <= cnt + 1;
        end
    end
end

// Result validity
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        // Start new operation
    end else if (res_valid &&!opn_valid) begin
        // Result consumed, reset validity
        res_valid <= 0;
    end
end

// Output assignment
assign result = (sign)? {remainder, quotient} : {remainder, quotient};

endmodule