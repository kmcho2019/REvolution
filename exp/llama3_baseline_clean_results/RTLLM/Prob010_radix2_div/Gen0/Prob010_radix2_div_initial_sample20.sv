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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Flag to start counter
reg [15:0] temp_result; // Temporary result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        temp_result <= 16'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize registers
            SR <= {1'b0, dividend};
            NEG_DIVISOR <= ~divisor + 1;
            if (sign) begin
                if (dividend[7]) begin
                    SR <= {1'b0, ~dividend + 1};
                end
                if (divisor[7]) begin
                    NEG_DIVISOR <= ~(~divisor + 1) + 1;
                end
            end
            start_cnt <= 1'b1;
            cnt <= 1;
        end else if (start_cnt) begin
            // Perform division
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 1'b0;
                cnt <= 3'b000;
                temp_result <= {SR[7:0], SR[7:0]};
                res_valid <= 1'b1;
            end else begin
                // Update shift register and counter
                reg [8:0] temp_SR;
                temp_SR <= SR - NEG_DIVISOR;
                if (temp_SR[8]) begin
                    SR <= {1'b0, SR[7:1]};
                end else begin
                    SR <= {1'b1, SR[7:1]};
                end
                cnt <= cnt + 1;
            end
        end else if (res_valid) begin
            // Result is valid, wait for consumption
            if (!opn_valid) begin
                res_valid <= 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (sign) begin
        if (dividend[7] && divisor[7]) begin
            result <= {temp_result[7:0], ~temp_result[7:0] + 1};
        end else if (dividend[7] || divisor[7]) begin
            result <= {temp_result[7:0], temp_result[7:0]};
        end else begin
            result <= temp_result;
        end
    end else begin
        result <= temp_result;
    end
end

endmodule