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
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter signal
reg [15:0] result_reg; // Result register

assign res_valid = (cnt == 0 && start_cnt == 0) || rst;
assign result = result_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result_reg <= 0;
    end else if (opn_valid &&!res_valid) begin
        SR <= {1'b0, dividend}; // Initialize shift register with absolute value of dividend
        NEG_DIVISOR <= ~divisor + 1; // Negated absolute value of divisor
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            result_reg <= {SR[7:0], SR[7:0]}; // Update result register
        end else begin
            // Update shift register based on subtraction result
            reg [8:0] sub_result;
            sub_result <= SR - NEG_DIVISOR;
            if (sub_result[8]) begin
                // No borrow, shift left and insert 1
                SR <= {1'b1, sub_result[7:0]};
            end else begin
                // Borrow, shift left and insert 0
                SR <= {1'b0, sub_result[7:0]};
            end
            cnt <= cnt + 1;
        end
    end
end

endmodule