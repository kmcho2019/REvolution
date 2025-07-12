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

// internal signals
reg [7:0] dividend_int;
reg [7:0] divisor_int;
reg [8:0] sr; // shift register
reg [8:0] neg_divisor; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg start_cnt; // flag to start the counter
reg [7:0] quotient;
reg [7:0] remainder;
reg valid_res;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset all signals
        dividend_int <= 0;
        divisor_int <= 0;
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        valid_res <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // save the inputs
            dividend_int <= sign ? {{7{dividend[7]}}, dividend[7:0]} : {8{1'b0}} + dividend;
            divisor_int <= sign ? {{7{divisor[7]}}, divisor[7:0]} : {8{1'b0}} + divisor;
            
            // initialize the shift register and neg_divisor
            sr <= {1'b0, dividend_int[7:0]};
            neg_divisor <= (~divisor_int + 1);
            
            // initialize the counter and start flag
            cnt <= 1;
            start_cnt <= 1'b1;
            valid_res <= 1'b0;
            res_valid <= 1'b0;
        end else if (start_cnt) begin
            // perform the division process
            if (cnt == 8) begin
                // division complete
                start_cnt <= 1'b0;
                cnt <= 0;
                valid_res <= 1'b1;
            end else begin
                // update the shift register and counter
                reg [8:0] tmp_sr;
                reg [8:0] tmp_neg_divisor;
                
                tmp_sr <= sr - neg_divisor;
                if (tmp_sr[8]) begin
                    // set the carry-out bit
                    sr <= {1'b0, sr[7:0]} + 1;
                end else begin
                    // clear the carry-out bit
                    sr <= {1'b1, sr[7:0]};
                end
                
                // increment the counter
                cnt <= cnt + 1;
            end
        end
        
        // manage the result validity
        if (valid_res && !res_valid) begin
            // update the result
            quotient <= sr[7:0];
            remainder <= sr[8] ? (8'h00 - sr[7:0]) : sr[7:0];
            result <= {remainder, quotient};
            res_valid <= 1'b1;
        end else if (rst) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule