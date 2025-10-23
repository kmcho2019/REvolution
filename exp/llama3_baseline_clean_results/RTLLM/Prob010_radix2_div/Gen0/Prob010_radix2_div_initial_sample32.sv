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
reg [15:0] sr;  // Shift register
reg [2:0] cnt;  // Counter
reg start_cnt;  // Start counter signal
reg [15:0] temp_result;  // Temporary result
reg temp_res_valid;  // Temporary result validity
reg [7:0] quotient;  // Quotient
reg [7:0] remainder;  // Remainder
wire signed_dividend;  // Signed dividend indicator
wire signed_divisor;  // Signed divisor indicator

assign signed_dividend = sign && dividend[7];
assign signed_divisor = sign && divisor[7];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        abs_dividend <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid &&!res_valid) begin
        abs_dividend <= signed_dividend? -dividend : dividend;
        abs_divisor <= signed_divisor? -divisor : divisor;
        neg_divisor <= abs_divisor;
        sr <= {1'b0, abs_dividend};  // Initialize shift register
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result
            quotient <= sr[7:0];
            remainder <= sr[15:8];
            temp_result <= {remainder, quotient};
            temp_res_valid <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            // Perform subtraction
            reg [8:0] temp_sr;
            reg carry_out;
            temp_sr <= sr[15:8] - neg_divisor;
            carry_out <= temp_sr[8];
            // Update shift register
            sr <= {carry_out, sr[15:8], sr[7:1]};
            // Increment counter
            cnt <= cnt + 1;
        end
    end
end

always @(posedge clk) begin
    if (temp_res_valid) begin
        result <= temp_result;
        res_valid <= 1;
    end else if (rst) begin
        result <= 0;
        res_valid <= 0;
    end
end

endmodule