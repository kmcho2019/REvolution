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

reg [15:0] dividend_reg;  // Register to store dividend
reg [7:0] divisor_reg;  // Register to store divisor
reg [2:0] cnt;  // Counter to track division process
reg start_cnt;  // Flag to start division process
reg [15:0] remainder;  // Register to store remainder
reg [7:0] quotient;  // Register to store quotient

// Initialize registers
initial begin
    res_valid = 0;
    dividend_reg = 0;
    divisor_reg = 0;
    cnt = 0;
    start_cnt = 0;
    remainder = 0;
    quotient = 0;
end

// Always block for sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
        remainder <= 0;
        quotient <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize registers
            dividend_reg <= sign ? {{8{dividend[7]}}, dividend} : {8'b0, dividend};
            divisor_reg <= sign ? {{8{divisor[7]}}, divisor} : {8'b0, divisor};
            cnt <= 1;
            start_cnt <= 1;
            remainder <= 0;
            quotient <= 0;
        end else if (start_cnt) begin
            // Division process
            if (cnt == 8) begin
                // Division complete
                cnt <= 0;
                start_cnt <= 0;
                result <= {remainder[7:0], quotient};
                res_valid <= 1;
            end else begin
                // Update remainder and quotient
                reg [16:0] temp;
                temp = remainder - divisor_reg;
                if (temp[16]) begin
                    remainder <= remainder;
                    quotient <= quotient;
                end else begin
                    remainder <= temp[15:0];
                    quotient <= quotient + 1;
                end
                cnt <= cnt + 1;
                remainder <= remainder << 1;
                remainder[0] <= dividend_reg[15 - cnt];
            end
        end else if (res_valid) begin
            // Reset result validity
            res_valid <= 0;
        end
    end
end

endmodule