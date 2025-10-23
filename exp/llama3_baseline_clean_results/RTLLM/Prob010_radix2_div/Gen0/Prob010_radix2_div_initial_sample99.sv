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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [8:0] sr; // Shift register to hold the dividend and quotient
reg [2:0] cnt; // Counter to manage the division process
reg start_cnt; // Flag to begin the division process
reg [15:0] result_reg; // Register to hold the final result
reg res_valid_reg; // Register to manage the result validity

// Multiplexer to select the result based on the carry-out
wire [8:0] sub_result;
wire carry_out;

assign sub_result = sr - {1'b0, neg_divisor};
assign carry_out = sub_result[8];

always @(*) begin
    case (carry_out)
        1'b0: result_reg = {sr[8:1], 1'b0};
        1'b1: result_reg = {sr[8:1], 1'b1};
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        sr <= 0;
        cnt <= 0;
        start_cnt <= 0;
        result_reg <= 0;
        res_valid_reg <= 0;
    end else if (opn_valid &&!res_valid_reg) begin
        // Save the inputs and initialize the shift register
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        neg_divisor <= ~divisor + 1;
        sr <= {1'b0, dividend_reg};
        cnt <= 1;
        start_cnt <= 1;
        res_valid_reg <= 0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            // Update the result register with the final remainder and quotient
            result_reg <= {sr[8:1], sr[0]};
            res_valid_reg <= 1;
        end else begin
            // Update the shift register and counter
            sr <= {carry_out, sr[8:1]};
            cnt <= cnt + 1;
        end
    end else if (!opn_valid && res_valid_reg) begin
        // Result validity management
        res_valid_reg <= 0;
    end
end

assign result = result_reg;
assign res_valid = res_valid_reg;

endmodule