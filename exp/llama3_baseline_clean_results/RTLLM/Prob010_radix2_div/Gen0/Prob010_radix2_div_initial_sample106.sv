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

reg [7:0] SR; // Shift register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter signal
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg sign_dividend; // Sign of dividend
reg sign_divisor; // Sign of divisor

// Initialize internal signals
initial begin
    SR = 0;
    NEG_DIVISOR = 0;
    cnt = 0;
    start_cnt = 0;
    res_valid = 0;
end

// Operation start
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= (sign ? {~dividend[7], dividend[7:0]} + 1 : dividend);
        abs_divisor <= (sign ? {~divisor[7], divisor[7:0]} + 1 : divisor);
        sign_dividend <= dividend[7];
        sign_divisor <= divisor[7];
        SR <= {1'b0, abs_dividend}; // Initialize shift register
        NEG_DIVISOR <= ~(abs_divisor) + 1; // Initialize negated absolute value of divisor
        cnt <= 1; // Initialize counter
        start_cnt <= 1; // Start division process
    end
end

// Division process
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result
            result <= {SR[15:8], SR[7:0]};
            if (sign_dividend ^ sign_divisor) begin
                result[7:0] <= ~(SR[7:0]) + 1;
            end
            res_valid <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            reg [8:0] temp;
            temp <= SR + NEG_DIVISOR;
            if (temp[8]) begin // Carry-out is 1
                SR <= {temp[8], SR[7:1]}; // Update shift register
            end else begin // Carry-out is 0
                SR <= {1'b0, SR[7:0]} + {8'b1, 8'b0}; // Update shift register
            end
            cnt <= cnt + 1;
        end
    end
end

// Result validity
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule