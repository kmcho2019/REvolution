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
reg [8:0] sr; // Shift register to hold dividend and quotient
reg [8:0] neg_divisor; // Negated divisor for subtraction
reg [3:0] cnt; // Counter for division steps
reg start_cnt; // Flag to indicate division has started
reg res_valid_reg; // Registered version of res_valid for combinational logic

// Signals for subtraction and result selection
wire [8:0] sub_result;
wire carry_out;

assign sub_result = sr - neg_divisor;
assign carry_out = (sub_result[8] == 1'b1)? 1'b0 : 1'b1;

always @(*) begin
    if (rst) begin
        res_valid_reg = 1'b0;
    end else if (opn_valid &&!res_valid_reg) begin
        // Save inputs and initialize registers
        dividend_reg = sign? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg = sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        sr = {1'b0, dividend_reg};
        neg_divisor = ~divisor_reg + 1;
        cnt = 1;
        start_cnt = 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete, update result and reset flags
            start_cnt = 1'b0;
            cnt = 4'b0;
            res_valid_reg = 1'b1;
            result = {sr[8:1], sr[0:0]};
        end else begin
            // Update shift register and increment counter
            sr = {carry_out, sr[8:1]};
            cnt = cnt + 1;
        end
    end else if (!opn_valid && res_valid_reg) begin
        // Reset res_valid when result is consumed
        res_valid_reg = 1'b0;
    end
end

assign res_valid = res_valid_reg;

endmodule