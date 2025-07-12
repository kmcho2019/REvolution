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

reg [15:0] SR; // shift register
reg [7:0] NEG_DIVISOR; // negated absolute value of divisor
reg [3:0] cnt; // counter
reg start_cnt; // flag to start division
reg [7:0] temp_dividend; // temporary dividend
reg [7:0] temp_divisor; // temporary divisor

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 16'd0;
        NEG_DIVISOR <= 8'd0;
        cnt <= 4'd0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        // save inputs
        temp_dividend <= dividend;
        temp_divisor <= divisor;
        
        // initialize shift register
        if (sign) begin
            SR <= { {8{temp_dividend[7]}} , (temp_dividend[7] ? ~temp_dividend + 1 : temp_dividend)} << 1;
        end else begin
            SR <= {8'd0, temp_dividend} << 1;
        end
        
        // set NEG_DIVISOR
        if (sign) begin
            if (temp_divisor[7]) begin
                NEG_DIVISOR <= ~(temp_divisor - 1);
            end else begin
                NEG_DIVISOR <= ~temp_divisor;
            end
        end else begin
            NEG_DIVISOR <= ~temp_divisor;
        end
        
        // set counter and start flag
        cnt <= 4'd1;
        start_cnt <= 1'b1;
        res_valid <= 1'b0;
    end else if (start_cnt) begin
        // division process
        if (cnt == 8'd8) begin
            // division complete
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            
            // update result
            if (sign) begin
                if ((SR[15] == 1'b0 && temp_dividend[7] == 1'b1) || (SR[15] == 1'b1 && temp_dividend[7] == 1'b0)) begin
                    result <= {SR[7:0], SR[15:8]};
                end else begin
                    result <= {~SR[7:0] + 1, SR[15:8]};
                end
            end else begin
                result <= {SR[15:8], SR[7:0]};
            end
            
            // set res_valid
            res_valid <= 1'b1;
        end else begin
            // update shift register
            if (SR[15] == 1'b1) begin
                SR <= SR << 1;
            end else begin
                SR <= (SR + NEG_DIVISOR) << 1;
            end
            
            // increment counter
            cnt <= cnt + 4'd1;
        end
    end else if (res_valid && !opn_valid) begin
        // reset res_valid
        res_valid <= 1'b0;
    end
end

endmodule