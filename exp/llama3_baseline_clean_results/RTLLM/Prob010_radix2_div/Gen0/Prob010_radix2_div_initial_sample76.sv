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

reg [7:0] SR;
reg [7:0] NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;
reg [15:0] temp_result;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 4'b0000;
        SR <= 8'b00000000;
        NEG_DIVISOR <= 8'b00000000;
        temp_result <= 16'b0000000000000000;
    end else begin
        if(opn_valid && !res_valid) begin
            SR <= {1'b0, dividend[7:0]};
            NEG_DIVISOR <= ~divisor[7:0] + 1'b1;
            start_cnt <= 1'b1;
            cnt <= 4'b0001;
        end else if(start_cnt) begin
            if(cnt == 8) begin
                start_cnt <= 1'b0;
                cnt <= 4'b0000;
                temp_result <= {SR[7:0], SR[7:0]};
                res_valid <= 1'b1;
            end else begin
                if(SR[7:0] >= NEG_DIVISOR) begin
                    SR <= {1'b1, SR[7:1]};
                end else begin
                    SR <= {1'b0, SR[7:1]};
                end
                SR <= SR - NEG_DIVISOR;
                cnt <= cnt + 1;
            end
        end
        if(res_valid && !opn_valid) begin
            res_valid <= 1'b0;
        end
    end
end

assign result = temp_result;

endmodule