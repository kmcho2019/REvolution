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
reg [7:0] neg_divisor_reg;
reg [15:0] shift_reg;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] quotient;
reg [7:0] remainder;
reg res_valid_reg;
wire [7:0] sub_result;
wire carry_out;

// Initialize signals
initial begin
    dividend_reg = 8'd0;
    divisor_reg = 8'd0;
    neg_divisor_reg = 8'd0;
    shift_reg = 16'd0;
    cnt = 3'd0;
    start_cnt = 1'd0;
    quotient = 8'd0;
    remainder = 8'd0;
    res_valid_reg = 1'd0;
end

// Subtraction
assign sub_result = shift_reg[7:0] - neg_divisor_reg;
assign carry_out = (shift_reg[7:0] < neg_divisor_reg) ? 1'd1 : 1'd0;

// Multiplexer
wire [7:0] mux_out;
assign mux_out = (carry_out == 1'd1) ? 8'd0 : sub_result;

// Shift register update
wire [15:0] shift_reg_next;
assign shift_reg_next = {shift_reg[14:0], carry_out};

// Counter increment
wire [2:0] cnt_next;
assign cnt_next = cnt + 1'd1;

always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        neg_divisor_reg <= 8'd0;
        shift_reg <= 16'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid_reg <= 1'd0;
    end else if (opn_valid && !res_valid_reg) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        
        // Initialize shift register and negated divisor
        if (sign) begin
            shift_reg <= {1'd0, (dividend_reg[7] == 1'd1) ? ~dividend_reg + 1'd1 : dividend_reg};
            neg_divisor_reg <= (divisor_reg[7] == 1'd1) ? ~divisor_reg + 1'd1 : divisor_reg;
        end else begin
            shift_reg <= {1'd0, dividend_reg};
            neg_divisor_reg <= divisor_reg;
        end
        
        // Initialize counter and start flag
        cnt <= 1'd1;
        start_cnt <= 1'd1;
    end else if (start_cnt) begin
        // Update shift register and counter
        if (cnt == 8'd8) begin
            // Division complete
            start_cnt <= 1'd0;
            cnt <= 3'd0;
            if (sign) begin
                quotient <= (dividend_reg[7] == 1'd1) ? ~shift_reg[7:0] + 1'd1 : shift_reg[7:0];
                remainder <= (divisor_reg[7] == 1'd1) ? ~shift_reg[15:8] + 1'd1 : shift_reg[15:8];
            end else begin
                quotient <= shift_reg[7:0];
                remainder <= shift_reg[15:8];
            end
            res_valid_reg <= 1'd1;
        end else begin
            shift_reg <= shift_reg_next;
            cnt <= cnt_next;
        end
    end else if (res_valid_reg) begin
        // Result validity
        if (rst || !opn_valid) begin
            res_valid_reg <= 1'd0;
        end
    end
end

assign result = {remainder, quotient};
assign res_valid = res_valid_reg;

endmodule