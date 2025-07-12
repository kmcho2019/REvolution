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
reg [15:0] sr; // shift register
reg [2:0] cnt; // counter
reg start_cnt;
reg [15:0] final_result;

// Reset logic
always @(posedge clk or posedge rst) begin
    if(rst) begin
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if(opn_valid &&!res_valid) begin
        // Save inputs and initialize variables
        if(sign) begin
            abs_dividend <= (dividend[7]? ~dividend + 1 : dividend);
            abs_divisor <= (divisor[7]? ~divisor + 1 : divisor);
        end else begin
            abs_dividend <= dividend;
            abs_divisor <= divisor;
        end
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
    end else if(start_cnt) begin
        // Division process
        if(cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            final_result <= sr;
            res_valid <= 1;
        end else begin
            // Update shift register and counter
            reg [8:0] sub_result;
            sub_result <= sr[7:0] - abs_divisor;
            if(sub_result[8]) begin
                sr <= {1'b0, sr[7:0]} << 1;
            end else begin
                sr <= {~sub_result[8], sub_result[7:0]} << 1;
            end
            cnt <= cnt + 1;
        end
    end else if(!opn_valid && res_valid) begin
        // Reset result validity when result is consumed
        res_valid <= 0;
    end
end

// Assign result
assign result = final_result;

endmodule