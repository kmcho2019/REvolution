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

reg [7:0] SR;  // Shift register to hold the remainder and quotient
reg [7:0] NEG_DIVISOR;  // Negated absolute value of the divisor
reg [2:0] cnt;  // Counter to track the division process
reg start_cnt;  // Flag to indicate the start of the division process
reg [15:0] temp_result;  // Temporary result to hold the quotient and remainder

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        cnt <= 3'b000;
        start_cnt <= 1'b0;
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            // Save inputs and initialize variables
            if (sign) begin
                SR <= {1'b0, (dividend[7] ? ~dividend + 1 : dividend)} << 1;
                NEG_DIVISOR <= ~(divisor[7] ? ~divisor + 1 : divisor) + 1;
            end else begin
                SR <= {1'b0, dividend} << 1;
                NEG_DIVISOR <= ~divisor + 1;
            end
            cnt <= 3'b001;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            // Perform division
            if (cnt == 3'b100) begin
                // Division complete, update outputs
                cnt <= 3'b000;
                start_cnt <= 1'b0;
                temp_result <= {SR[15:8], SR[7:0]};
                res_valid <= 1'b1;
            end else begin
                // Update shift register and counter
                reg [8:0] sub_result;
                sub_result <= SR[15:8] - NEG_DIVISOR;
                SR <= {sub_result[8], sub_result[7:0]} << 1 | SR[0];
                cnt <= cnt + 1'b1;
            end
        end
        // Manage result validity
        if (rst || (!opn_valid && res_valid)) begin
            res_valid <= 1'b0;
        end
    end
end

assign result = temp_result;

endmodule