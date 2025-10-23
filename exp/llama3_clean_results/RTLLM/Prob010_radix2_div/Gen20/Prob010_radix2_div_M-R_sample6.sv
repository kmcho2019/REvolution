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

// Define states as an enumeration
enum logic [1:0] {
    IDLE,
    INIT,
    DIVIDE,
    DONE
} state, next_state;

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;

// Combinational logic for next state
assign next_state = (state == IDLE && opn_valid && !res_valid) ? INIT :
                   (state == INIT) ? DIVIDE :
                   (state == DIVIDE && cnt == 8) ? DONE :
                   (state == DONE && !opn_valid) ? IDLE : state;

// Combinational logic for neg_divisor
assign neg_divisor = ~divisor_reg + 1;

// Combinational logic for shift_reg update
wire [15:0] shift_reg_next;
assign shift_reg_next = (shift_reg[15:8] >= divisor_reg) ? {shift_reg[15:8] - divisor_reg, 1'b1, shift_reg[7:1]} : {shift_reg[15:8], 1'b0, shift_reg[7:1]};

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        state <= next_state;
        res_valid <= (next_state == DONE) ? 1'b1 : (opn_valid && next_state != DONE) ? res_valid : 1'b0;

        case(next_state)
            INIT: begin
                dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                shift_reg <= {8'b0, dividend_reg};
                cnt <= 1;
                start_cnt <= 1;
            end
            DIVIDE: begin
                shift_reg <= shift_reg_next;
                cnt <= cnt + 1;
            end
            DONE: begin
                result <= {shift_reg[15:8], shift_reg[7:0]};
            end
        endcase
    end
end

endmodule