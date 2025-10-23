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

reg [15:0] SR;  // Shift register to store dividend and quotient
reg [7:0] NEG_DIVISOR;  // Negated absolute value of divisor
reg [2:0] cnt;  // Counter to track division process
reg start_cnt;  // Flag to start division process

// Initialize registers
initial begin
    res_valid = 0;
    SR = 0;
    NEG_DIVISOR = 0;
    cnt = 0;
    start_cnt = 0;
end

// Always block for sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize registers
            SR <= {1'b0, dividend};
            NEG_DIVISOR <= (~divisor[7] ? -divisor : ~divisor + 1);
            cnt <= 1;
            start_cnt <= 1;
        end else if (start_cnt) begin
            // Division process
            if (cnt == 8) begin
                // Division complete
                cnt <= 0;
                start_cnt <= 0;
                result <= {SR[15:8], SR[7:0]};
                res_valid <= 1;
            end else begin
                // Update shift register and counter
                reg [8:0] temp;
                temp = {1'b0, SR[7:0]} - NEG_DIVISOR;
                SR <= {temp[8], SR[7:0]} << 1;
                cnt <= cnt + 1;
            end
        end else if (res_valid) begin
            // Reset result validity
            res_valid <= 0;
        end
    end
end

endmodule