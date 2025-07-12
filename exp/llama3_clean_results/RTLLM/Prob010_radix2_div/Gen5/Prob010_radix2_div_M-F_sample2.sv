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
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient;
reg [7:0] remainder;
reg [2:0] counter;
reg start_cnt;
reg [15:0] sr; // Shift register
reg neg_divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        counter <= 0;
        start_cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient <= 0;
        remainder <= 0;
        sr <= 0;
        neg_divisor <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save the inputs dividend and divisor
            if (sign) begin
                // Signed division
                dividend_reg <= (dividend[7] ? 8'hFF : 8'h00) + dividend;
                divisor_reg <= (divisor[7] ? 8'hFF : 8'h00) + divisor;
            end else begin
                // Unsigned division
                dividend_reg <= dividend;
                divisor_reg <= divisor;
            end
            neg_divisor <= ~divisor_reg + 1;
            sr <= {1'b0, dividend_reg}; // Initialize shift register
            counter <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end
        
        if (start_cnt) begin
            if (counter == 8) begin
                // Division complete
                counter <= 0;
                start_cnt <= 0;
                res_valid <= 1;
                quotient <= sr[7:0];
                remainder <= sr[15:8];
            end else begin
                // Perform division
                reg [8:0] sub;
                sub = {1'b0, sr[7:0]} - divisor_reg;
                if (sub[8]) begin
                    // No borrow
                    sr <= {1'b0, sr[7:0]} << 1;
                end else begin
                    // Borrow
                    sr <= ({1'b1, sr[7:0]} + (divisor_reg << 1)) << 1;
                end
                counter <= counter + 1;
            end
        end
    end
end

assign result = {remainder, quotient};

endmodule