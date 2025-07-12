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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;
reg [1:0] state; // 0: idle, 1: init, 2: divide

// Next state logic
wire next_state_idle = (rst || (!opn_valid && state == 0)) ? 1'b1 : 1'b0;
wire next_state_init = (opn_valid && state == 0) ? 1'b1 : 1'b0;
wire next_state_divide = (state == 1) ? 1'b1 : 1'b0;
wire next_state_done = (cnt == 8) ? 1'b1 : 1'b0;

assign next_state = (next_state_idle ? 2'b00 :
                     next_state_init ? 2'b01 :
                     next_state_divide ? 2'b10 :
                     next_state_done ? 2'b00 : 2'b00);

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        state <= 2'b00;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        state <= next_state;
        case (state)
            2'b00: begin // Idle
                if (opn_valid) begin
                    dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                    divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                    neg_divisor <= ~divisor_reg + 1;
                    shift_reg <= {8'b0, dividend_reg};
                    cnt <= 0;
                    start_cnt <= 1;
                end
            end
            2'b01: begin // Initialize
                state <= 2'b10;
            end
            2'b10: begin // Divide
                if (cnt == 8) begin
                    result <= {shift_reg[15:8], shift_reg[7:0]};
                    res_valid <= 1;
                    state <= 2'b00;
                end else begin
                    if (shift_reg[15:8] >= divisor_reg) begin
                        shift_reg <= {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]};
                    end else begin
                        shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
                    end
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

// Result validity management
always @(posedge clk) begin
    if (rst || (!opn_valid && res_valid)) begin
        res_valid <= 0;
    end
end

endmodule